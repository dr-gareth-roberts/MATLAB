%%#########################################################################
% Auditory Oddball - EEG Analysis
% Script organised into MATLAB cells to facilitate analysis.
% Complete analysis pipeline for AO study in MATLAB. Requires EEGLAB.
% Gareth Roberts, 2014. Murdoch University.
%#########################################################################

clc; clear; close; eeglab

% what to run
runICA = 0; % 0 = no, 1 = yes

%% CONSTANTS
DATA_PATH = '/home/gareth/Documents/Listening to the Oddballs/cnt/';
CHAN_LOCATIONS = '/home/gareth/matlab/toolbox/eeglab13_2_2b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp';
RESULTS_PATH = '/home/gareth/Documents/Listening to the Oddballs/ICA/';

% Analysis Parameters
FILTER_LOWER_EDGE = 0.5;
FILTER_UPPER_EDGE = 30;
EPOCH_LENGTH = [-.1 .7];
BASELINE_CORRCTION = [-100 0];
REFERENCE = []; %average reference

% Part 1
% get everything ready (paths, eeglab, current directory, etc.)
cd (DATA_PATH);
currentDir = (DATA_PATH);

% get the files in the directory and count how many there are
cntFilesinDir=dir(fullfile(currentDir,'*.cnt'));
nCntFiles=length(cntFilesinDir);

%% ICA part
    for cntfile = 1:nCntFiles
        loadCnt=(cntFilesinDir(cntfile).name);
        cntLocation=strcat(currentDir,loadCnt);
        EEG = pop_loadcnt(cntLocation, 'dataformat', 'auto'); 
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',loadCnt,'gui','off'); 
        EEG=pop_chanedit(EEG, 'lookup',CHAN_LOCATIONS);
        % filter - lower edge 1hz
        EEG = pop_eegfiltnew(EEG, [], 0.1, 8250, true, [], 0);
        %EEG = pop_eegfilt( EEG, 1, 0, [], [0], 0, 0, 'fir1', 0);
        % filter - higher edge 30hz
        EEG = pop_eegfiltnew(EEG, [], 30, 110, 0, [], 0);
        %EEG = pop_eegfilt( EEG, 0, 30, [], [0], 0, 0, 'fir1', 0);
        % remove unnecessary channels
        EEG = pop_select( EEG,'nochannel',{'VEOGL' 'VEOGU' 'CPZ-NC' 'X7-NC' 'X8-NC'});
        %reref
        EEG = pop_reref( EEG, [] );
        if runICA == 1
            %run ICA
            EEG = pop_runica(EEG, 'extended',1,'interupt','on');
            %dipole fitting
            EEG = pop_dipfit_settings( EEG, 'hdmfile','/home/gareth/matlab/toolbox/eeglab13_2_2b/plugins/dipfit2.3/standard_BEM/standard_vol.mat','coordformat','MNI','mrifile','/home/gareth/matlab/toolbox/eeglab13_2_2b/plugins/dipfit2.3/standard_BEM/standard_mri.mat','chanfile','/home/gareth/matlab/toolbox/eeglab13_2_2b/plugins/dipfit2.3/standard_BEM/elec/standard_1005.elc','coord_transform',[0.83215 -15.6287 2.4114 0.081214 0.00093739 -1.5732 1.1742 1.0601 1.1485] ,'chansel',[1:35] );
            EEG = pop_multifit(EEG, [1:35] ,'threshold',100,'plotopt',{'normlen' 'on'});
        end;
        %save file
        rerefname = strcat(loadCnt,'_ICA.set');
        finalLoc = strcat(RESULTS_PATH,rerefname);
        strFinalLoc = char(finalLoc);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',strFinalLoc,'overwrite','on','gui','off');         
    end;

%% Epoch part
    datapath = '/home/gareth/Documents/Listening to the Oddballs/ICA/';
    resultspath = '/home/gareth/Documents/Listening to the Oddballs/epochs1/';
    
    cd (datapath);
    currentDir = (datapath);
   
    setFilesinDir=dir(fullfile(currentDir,'*.set'));
    nSetFiles=length(setFilesinDir);   

     for setfile = 1:nSetFiles
        loadSet=(setFilesinDir(setfile).name);
        setLocation=strcat(currentDir,loadSet);
    
        EEG = pop_loadset('filename',setLocation);
        
        %epoching
        EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString',...
        { 'boundary' } );
        EEG = pop_overwritevent( EEG, 'code');
        EEG  = pop_binlister( EEG , 'BDF', '/home/gareth/Documents/Listening to the Oddballs/bins_auditory_oddball.txt', 'IndexEL',  1, 'SendEL2', 'EEG', 'UpdateEEG', 'on', 'Voutput', 'EEG' ); 
        EEG = pop_overwritevent( EEG, 'binlabel');
       
        stimTimePeriod = [-0.1           .7];
        stimBaselinePeriod = [-100    0];

        EEG = pop_epoch( EEG, {  'B1(2)'  'B2(3)'  'B3(4)'  'B3(5)'  'B3(6)'  'B3(7)'  }, stimTimePeriod);
        % Remove baseline
        EEG = pop_rmbase( EEG,stimBaselinePeriod);
        %extreme value rej
        EEG = pop_eegthresh(EEG,1,[1:35] ,-100,100,-0.1,0.696,0,1);
        %save file
        rerefname = strcat(loadSet(1:4),'_epoch1.set');
        finalLoc = strcat(resultspath,rerefname);
        strFinalLoc = char(finalLoc);
        EEG = eeg_checkset( EEG );
        EEG = pop_saveset( EEG,'filename',rerefname,'filepath',resultspath);
    end; 

 %% Separate epochs
    datapath = '/home/gareth/Documents/Listening to the Oddballs/epochs1/';
    resultspath = '/home/gareth/Documents/Listening to the Oddballs/epochs2/';

    cd (datapath);
    currentDir = (datapath);
   
    setFilesinDir=dir(fullfile(currentDir,'*.set'));
    nSetFiles=length(setFilesinDir);   

     for setfile = 1:nSetFiles
            loadSet=(setFilesinDir(setfile).name);
            setLocation=strcat(currentDir,loadSet);
            
            % make directory for each participant to make it easier when
            % creating a study design
            subjectName = loadSet(1:4);
            mkdir(resultspath, subjectName);
            subjectDir = strcat(resultspath,subjectName,'/');
            
            % load set file
            EEG = pop_loadset('filename',setLocation);
            
            % create standard epochs
            EEG = pop_epoch( EEG, { 'B1(2)' }, EPOCH_LENGTH, 'newname', 'standard', 'epochinfo', 'yes');
            EEG = pop_rmbase( EEG, BASELINE_CORRCTION);
            EEG = pop_saveset( EEG,'filename',strcat(loadSet(1:4),'_standards'),'filepath',subjectDir);
            pop_export(EEG,strcat(pwd,'/',loadSet(1:4),'_erp'),'erp','on');
            EEG = pop_loadset('filename',setLocation);
            
            % create target epochs
            EEG = pop_epoch( EEG, {  'B2(3)'  }, EPOCH_LENGTH, 'newname', 'target', 'epochinfo', 'yes');
            EEG = pop_rmbase( EEG, BASELINE_CORRCTION);
            EEG = pop_saveset( EEG,'filename',strcat(loadSet(1:4),'_targets'),'filepath',subjectDir);
            pop_export(EEG,strcat(pwd,'/',loadSet(1:4),'_erp'),'erp','on');
            EEG = pop_loadset('filename',setLocation);
            
            % create novel epochs
            EEG = pop_epoch( EEG, { 'B3(4)'  'B3(5)'  'B3(6)' 'B3(7)' }, EPOCH_LENGTH, 'newname', 'novel', 'epochinfo', 'yes');
            EEG = pop_rmbase( EEG, BASELINE_CORRCTION);
            EEG = pop_saveset( EEG,'filename',strcat(loadSet(1:4),'_novels'),'filepath',subjectDir);
            pop_export(EEG,strcat(pwd,'/',loadSet(1:4),'_erp'),'erp','on');
            EEG = pop_loadset('filename',setLocation);
     end;
   

%% part 4 - Create a study design
basedir = '/home/gareth/Documents/Listening to the Oddballs/epochs2/';

subjs = {'5025'	'5029'	'5031'	'5035'	'5037'	'5039'	'5047'	'5049'	'5051'	'5061'	'5063'	'5066'	'5073'	'5076'	'5081'	'5083'	'5085'...
'5027'	'5030'	'5034'	'5036'	'5038'	'5040'	'5048'	'5050'	'5060'	'5062'	'5064'	'5072'	'5074'	'5080'	'5082'	'5084'	'5086'};

commands = {}; % initialize STUDY dataset list

% Now loop through subjects and add to the STUDY
for subj = 1:length(subjs) % for each subject
    fileNovels   = fullfile(basedir, subjs{subj}, strcat(subjs{subj},'_novels.set'));
    fileTargets = fullfile(basedir, subjs{subj}, strcat(subjs{subj},'_targets.set'));
    fileStandards   = fullfile(basedir, subjs{subj}, strcat(subjs{subj},'_standards.set'));
    commands = { commands{:} ...
           {'index' 3*subj-2 'load' fileNovels   'subject' subjs{subj} 'condition' 'novels' } ...
           {'index' 3*subj-1 'load' fileTargets 'subject' subjs{subj} 'condition' 'targets' } ...
           {'index' 3*subj   'load' fileStandards    'subject' subjs{subj} 'condition' 'standards' } };
end;
commands = { commands{:} { 'dipselect', 0.15 } };
[STUDY ALLEEG] = std_editset( STUDY, ALLEEG, 'name', 'AO task', ...
     'task', 'AO', 'commands', commands, ...
     'updatedat','off', 'filename', fullfile(basedir, 'AO_final.study'));

% update workspace variables and redraw EEGLAB
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
[STUDY, ALLEEG] = std_checkset(STUDY, ALLEEG);
eeglab redraw;

%% part 5 - Compute some measures (ERPs, spectra, time-frequency, etc.)
%create ERPs
[STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, {},'interp','on','recompute','on','erp','on','spec','on','specparams',{'specmode' 'fft' 'logtrials' 'off'},'ersp','on','erspparams',{'cycles' 0},'itc','on');
