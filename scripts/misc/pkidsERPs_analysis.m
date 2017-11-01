%%#########################################################################
% ERP Flanker Analysis
% Gareth Roberts - Murdoch University
%#########################################################################

clc; clear; close; eeglab

%% CONSTANTS
DATA_PATH = '/media/DATAPART1/Gareth/PKIDS Flanker/raw/'; %input..i.e, where the data files live
CHAN_LOCATIONS = '/home/gareth/matlab/toolbox/eeglab13_2_2b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp';
RESULTS_PATH = '/media/DATAPART1/Gareth/FlankerSeq/setFiles/';
ERP_PATH = '/media/DATAPART1/Gareth/FlankerSeq/ERPs/';

%% Part 1 = load file, load chan locs, filter 1-30 Hz - THIS IS TO GET ICA WEIGHTS TO USE FOR A SUBSEQUENT FILE WHICH HAS A LOWER FILTER (0.1 Hz)
% get everything ready (paths, eeglab, current directory, etc.)
cd (DATA_PATH);
currentDir = (DATA_PATH);

% get the files in the directory and count how many there are
cntFilesinDir=dir(fullfile(currentDir,'*.cnt'));
nCntFiles=length(cntFilesinDir);
   
    for cntfile = 1:nCntFiles
        try
            loadCnt=(cntFilesinDir(cntfile).name);
            cntLocation=strcat(currentDir,loadCnt);
            EEG = pop_loadcnt(cntLocation, 'dataformat', 'auto'); 
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',loadCnt,'gui','off'); 
            EEG=pop_chanedit(EEG, 'lookup',CHAN_LOCATIONS);

            % filter - lower edge 1hz
            EEG = pop_eegfilt( EEG, 1, 0, [], [0], 0, 0, 'fir1', 0);
            % filter - higher edge 30hz
            EEG = pop_eegfilt( EEG, 0, 30, [], [0], 0, 0, 'fir1', 0);

            %remove unused channels
            EEG = pop_select( EEG,'nochannel',{'VEOGL' 'VEOGU' 'CPZ-NC' 'X7-NC' 'X8-NC'});

            %reref the data
            EEG = pop_reref( EEG, [24 30] );

            %run ICA
            EEG = pop_runica(EEG, 'extended', 1,'interupt','on');

            % save dataset
            EEG = pop_saveset( EEG,'filename',strcat(loadCnt(1:8),'_ICA'),'filepath',RESULTS_PATH);

            %export ICA weights
            pop_expica(EEG, 'weights', '/media/DATAPART1/Gareth/PKIDS Flanker/raw/2573fr07weights.txt');
        catch
        end;
    end;
%% Part 2 = do the same as above but without the ICA. Load ICA weights from file above.
   for cntfile = 1:nCntFiles
        try
            loadCnt=(cntFilesinDir(cntfile).name);
            cntLocation=strcat(currentDir,loadCnt);
            EEG = pop_loadcnt(cntLocation, 'dataformat', 'auto'); 
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',loadCnt,'gui','off'); 
            EEG=pop_chanedit(EEG, 'lookup',CHAN_LOCATIONS);

            %remove unused channels
            EEG = pop_select( EEG,'nochannel',{'VEOGL' 'VEOGU' 'CPZ-NC' 'X7-NC' 'X8-NC'});

            % filter - 0.1 to 30 Hz
            EEG  = pop_basicfilter( EEG,  1:33 , 'Cutoff', [ 0.1 30], 'Design', 'butter', 'Filter', 'bandpass', 'Order',2);

            %reref the data
            EEG = pop_reref( EEG, [24 30] );

            %load ICA weights
            EEG = pop_editset(EEG, 'icaweights', strcat('/media/DATAPART1/Gareth/PKIDS Flanker/raw/',loadCnt(1:8),'_ica.txt');

            EEG = pop_saveset( EEG,'filename',strcat(loadCnt(1:8),'_ICA'),'filepath',RESULTS_PATH);
        catch
        end;
    end;
    
%% Part 3 = Load file with correct filter and ICA weights and do some epoching and artefact rejection
DATA_PATH = '/media/DATAPART1/Gareth/FlankerSeq/setFiles/final_ICA/';
cd (DATA_PATH);
currentDir = (pwd);
RESULTS_PATH = '/media/DATAPART1/Gareth/FlankerSeq/setFiles/epochs/';

% get the files in the directory and count how many there are
 setFilesinDir=dir(fullfile(currentDir,'*.set'));
 nSetFiles=length(setFilesinDir);

    for setfile = 1:nSetFiles
        loadSet=(setFilesinDir(setfile).name);
        setLocation=strcat(currentDir,'/',loadSet);
        EEG = pop_loadset(setLocation);
        
        %epoching
        EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString',...
        { 'boundary' } );
        EEG = pop_overwritevent( EEG, 'code');
        EEG  = pop_binlister( EEG , 'BDF', '/media/DATAPART1/Gareth/flanker.txt', 'ExportEL', strcat('/media/DATAPART1/Gareth/FlankerSeq/Events/',char(loadCnt(1:8)),'_events.txt'), 'IndexEL',  1, 'SendEL2', 'EEG&Text', 'UpdateEEG', 'on', 'Voutput', 'EEG' ); 
        EEG = pop_overwritevent( EEG, 'binlabel');
        
        % create epochs
        EEG = pop_epoch( EEG, {  'B1(1)' 'B1(2)' 'B2(3)' 'B2(4)' 'B3(5)' 'B3(6)' }, [-.2 1]);
        EEG = pop_rmbase( EEG, [-200 0]);
        EEG = pop_saveset( EEG,'filename',strcat(loadSet(1:8),'_std_epochs'),'filepath',RESULTS_PATH, 'check', 'on', 'savemode', 'onefile');             
    end; 

%% part 4
DATA_PATH = '/media/DATAPART1/Gareth/FlankerSeq/setFiles/epochs/';
cd (DATA_PATH);
currentDir = (pwd);
RESULTS_PATH = '/media/DATAPART1/Gareth/FlankerSeq/setFiles/epochs/';
EPOCH_LENGTH = [-.2 1];

% get the files in the directory and count how many there are
 setFilesinDir=dir(fullfile(currentDir,'*.set'));
 nSetFiles=length(setFilesinDir);

    for setfile = 1:nSetFiles
        loadSet=(setFilesinDir(setfile).name);
        setLocation=strcat(currentDir,'/',loadSet);
        EEG = pop_loadset('filename',setLocation);
        
        % make directory for each participant to make it easier when
        % creating a study design
        subjectName = loadSet(1:8);
        mkdir(RESULTS_PATH, subjectName);
        subjectDir = strcat(RESULTS_PATH,subjectName,'/');
     
        % create congruous epochs
        EEG = pop_epoch( EEG, { 'B1(1)'  'B1(2)' }, EPOCH_LENGTH, 'newname', 'congruous', 'epochinfo', 'yes');
        %EEG = pop_rmbase( EEG, BASELINE_CORRECTION);
        EEG = pop_saveset( EEG,'filename',strcat(loadSet(1:8),'_congruous'),'filepath',subjectDir, 'check', 'on', 'savemode', 'onefile');
        EEG = pop_loadset('filename',setLocation);

        %create incongrous epochs
        EEG = pop_epoch( EEG, {  'B2(3)'  'B2(4)'  }, EPOCH_LENGTH, 'newname', 'incongruous', 'epochinfo', 'yes');
        %EEG = pop_rmbase( EEG, BASELINE_CORRECTION);
        EEG = pop_saveset( EEG,'filename',strcat(loadSet(1:8),'_incongruous'),'filepath',subjectDir);
        EEG = pop_loadset('filename',setLocation);

        % create switch epochs
        EEG = pop_epoch( EEG, {  'B3(5)'  'B3(6)' }, EPOCH_LENGTH, 'newname', 'switch', 'epochinfo', 'yes');
        %EEG = pop_rmbase( EEG, BASELINE_CORRECTION);
        EEG = pop_saveset( EEG,'filename',strcat(loadSet(1:8),'_switch'),'filepath',subjectDir);
        EEG = pop_loadset('filename',setLocation);
    end;
   %% 
    basedir = '/media/DATAPART1/Gareth/FlankerSeq/setFiles/epochs/';
 
listDirs
subjs = ans;

 commands = {}; % initialize STUDY dataset list
 
 % Now loop through subjects and add to the STUDY
 for subj = 1:length(subjs) % for each subject
    fileNoGO   = fullfile(basedir, subjs{subj}, strcat(subjs{subj},'_switch.set'));
    fileIncongruous = fullfile(basedir, subjs{subj}, strcat(subjs{subj},'_incongruous.set'));
    fileCongruous   = fullfile(basedir, subjs{subj}, strcat(subjs{subj},'_congruous.set'));


    commands = { commands{:} ...
           {'index' 3*subj-2 'load' fileNoGO   'subject' subjs{subj} 'condition' 'Switch'  } ...
           {'index' 3*subj-1 'load' fileIncongruous 'subject' subjs{subj} 'condition' 'Incongruous'  } ...
           {'index' 3*subj   'load' fileCongruous    'subject' subjs{subj} 'condition' 'Congruous' } };
end;

commands = { commands{:} { 'dipselect', 0.99 } };
[STUDY ALLEEG] = std_editset( STUDY, ALLEEG, 'name', 'Flanker task', ...
     'task', 'Flanker', 'commands', commands, ...
     'updatedat','off', 'filename', fullfile(basedir, 'pkids.study'));

% update workspace variables and redraw EEGLAB
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
[STUDY, ALLEEG] = std_checkset(STUDY, ALLEEG);
eeglab redraw;

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    %% possible analysis strategy
    % 1. run ICA and subtract eye blinks and eye saccades from the sensor
    % data
    % 2. perform mass-univariate statistics for group differences (7 versus 9)
    % and the main hypothesis tests (cC versus iC)
    % 3. extract all amplitude and latency data and use linear model
    % 4. perform time-frequency analyses using FFT. extract ERSP and ITC values at
    % time periods of interest. put results into linear model
    % 5. compute phase and power coupling analyses between Fz and Pz, and
    % FCz and Iz
    % - do behavioural analysis for all trials and ERP-included trials
    
    % export ICA weights from dataset
    
    

    

    


        EEG = pop_epochbin( EEG , [-200.0  1000.0],  'pre');
        
        % do artefact rejection
        EEG  = pop_artextval( EEG , 'Channel',  1:33, 'Flag', 1, 'Threshold', [ -85 85], 'Twindow', [ -100 996] );
        EEG  = pop_artmwppth( EEG , 'Channel',  1:33, 'Flag',  1, 'Threshold',  100, 'Twindow', [ -100 996], 'Windowsize',  200, 'Windowstep',100);
        EEG  = pop_artstep( EEG , 'Channel',  1:33, 'Flag',  1, 'Threshold',  100, 'Twindow', [ -100 996], 'Windowsize',  200, 'Windowstep',100);
        
        %save file
        ERP = pop_averager( EEG , 'Criterion', 'good', 'ExcludeBoundary', 'on', 'SEM', 'on' );
        ERP = pop_savemyerp(ERP, 'erpname', char(loadSet(1:8)), 'filename',strcat(char(loadSet(1:8)),'.erp'), 'filepath', RESULTS_PATH, 'Warning', 'on');
        
        % export RTs
        values = pop_rt2text(ERP, 'eventlist',  1, 'filename', strcat('/media/DATAPART1/Gareth/FlankerSeq/RTs/',char(loadSet(1:8)),'_rts.txt'), 'header', 'on', 'listformat', 'basic' );
        

                
