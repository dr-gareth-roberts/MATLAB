%%#########################################################################
% Flanker Time-frequency Analysis
% Script organised into MATLAB cells to facilitate analysis.
% Complete analysis pipeline for Flanker task in MATLAB. Requires EEGLAB.
% Gareth Roberts, 2014. Murdoch University.
%##########################################################################

clc; clear; close; eeglab
tic;

%% ANALYSIS OPTIONS
runICA = 1; % 0 = no, 1 = yes
filtType = 0; % 0 = old EEGLAB filter, 1 = new EEGLAB filter

%% CONSTANTS
DATA_PATH = '/home/gareth/Documents/Fishing with the Flanker/cnt/';
CHAN_LOCATIONS = '/home/gareth/matlab/toolbox/eeglab13_2_2b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp';
RESULTS_PATH = '/home/gareth/Documents/Fishing with the Flanker/UltimateFish/ICA/';

% Analysis Parameters
FILTER_LOWER_EDGE = 1;
FILTER_UPPER_EDGE = 30;
EPOCH_LENGTH = [-.2 1];
BASELINE_CORRCTION = [-200 0];
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
        EEG = pop_eegfilt( EEG, 1, 0, [], [0], 0, 0, 'fir1', 0);
        % filter - higher edge 30hz
        EEG = pop_eegfilt( EEG, 0, 30, [], [0], 0, 0, 'fir1', 0);
        
        %epoching
        EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString',...
        { 'boundary' } );
        EEG = pop_overwritevent( EEG, 'code');
        EEG  = pop_binlister( EEG , 'BDF', '/home/gareth/Documents/Fishing with the Flanker/bins_flanker_nogo.txt', 'IndexEL',  1, 'SendEL2', 'EEG', 'UpdateEEG', 'on', 'Voutput', 'EEG' ); 
        EEG = pop_overwritevent( EEG, 'binlabel');
        stimTimePeriod = [-0.2           1];
        stimBaselinePeriod = [-200    0];
        EEG = pop_epoch( EEG, {  'B1(1)'  'B1(2)'  'B2(3)'  'B2(4)'  'B3(5)'  'B3(6)'  'B5(3)'  'B5(4)'  'B6(5)'  }, stimTimePeriod);
        
        % Remove baseline
        EEG = pop_rmbase( EEG,stimBaselinePeriod);
        % remove unnecessary channels
        EEG = pop_select( EEG,'nochannel',{'CPZ-NC' 'X7-NC' 'X8-NC'});
        %reref
        EEG = pop_reref( EEG, [] );
        
        %work out how old subject is based on their filename and then do
        %different artefact rejection criteria based on that
        subjectAge = str2num(loadCnt(7:8));     
        if subjectAge == 7 || 8 || 9 || 10 || 11 
            %extreme value reject
            EEG = pop_eegthresh(EEG,1,[1:37] ,-150,150,-0.2,0.996,0,1);
        else
            EEG = pop_eegthresh(EEG,1,[1:37] ,-85,85,-0.2,0.996,0,1);
        end;
        
        %reref
        EEG = pop_reref( EEG, [] );
        
        if runICA == 1
            %run ICA
            EEG = pop_runica(EEG, 'extended',1,'interupt','on');
            %dipole fitting
            EEG = pop_dipfit_settings( EEG, 'hdmfile','/home/gareth/matlab/toolbox/eeglab13_2_2b/plugins/dipfit2.3/standard_BEM/standard_vol.mat','coordformat','MNI','mrifile','/home/gareth/matlab/toolbox/eeglab13_2_2b/plugins/dipfit2.3/standard_BEM/standard_mri.mat','chanfile','/home/gareth/matlab/toolbox/eeglab13_2_2b/plugins/dipfit2.3/standard_BEM/elec/standard_1005.elc','coord_transform',[0.83215 -15.6287 2.4114 0.081214 0.00093739 -1.5732 1.1742 1.0601 1.1485] ,'chansel',[1:35] );
            EEG = pop_multifit(EEG, [1:37] ,'threshold',100,'plotopt',{'normlen' 'on'});
        end;
        
        %save file
        rerefname = strcat(loadCnt,'_ICA.set');
        finalLoc = strcat(RESULTS_PATH,rerefname);
        strFinalLoc = char(finalLoc);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',strFinalLoc,'overwrite','on','gui','off');         
    end;
    %% Separate epochs
    datapath = '/home/gareth/Documents/Fishing with the Flanker/UltimateFish/ICA/';
    resultspath = '/home/gareth/Documents/Fishing with the Flanker/UltimateFish/epochs/';

    cd (datapath);
    currentDir = (datapath);
   
    setFilesinDir=dir(fullfile(currentDir,'*.set'));
    nSetFiles=length(setFilesinDir);   

     for setfile = 1:nSetFiles
            loadSet=(setFilesinDir(setfile).name);
            setLocation=strcat(currentDir,loadSet);

            % load set file
            EEG = pop_loadset('filename',setLocation);
            
            % make directory for each participant to make it easier when
            % creating a study design
            subjectName = loadSet(1:4);
            mkdir(resultspath, subjectName);
            subjectDir = strcat(resultspath,subjectName,'/');
            
            % create congruous epochs
            EEG = pop_epoch( EEG, { 'B1(1)'  'B1(2)' }, EPOCH_LENGTH, 'newname', 'congruous', 'epochinfo', 'yes');
            EEG = pop_rmbase( EEG, BASELINE_CORRCTION);
            EEG = pop_saveset( EEG,'filename',strcat(loadSet(1:4),'_congruous'),'filepath',subjectDir);
            EEG = pop_loadset('filename',setLocation);
            
            % create incongrous epochs
            EEG = pop_epoch( EEG, {  'B2(3)'  'B2(4)'  }, EPOCH_LENGTH, 'newname', 'incongruous', 'epochinfo', 'yes');
            EEG = pop_rmbase( EEG, BASELINE_CORRCTION);
            EEG = pop_saveset( EEG,'filename',strcat(loadSet(1:4),'_incongruous'),'filepath',subjectDir);
            EEG = pop_loadset('filename',setLocation);
            
            % create noGO epochs
            EEG = pop_epoch( EEG, {  'B3(5)'  'B3(6)' }, EPOCH_LENGTH, 'newname', 'noGO', 'epochinfo', 'yes');
            EEG = pop_rmbase( EEG, BASELINE_CORRCTION);
            EEG = pop_saveset( EEG,'filename',strcat(loadSet(1:4),'_noGO'),'filepath',subjectDir);
            EEG = pop_loadset('filename',setLocation);
     end;

%% Create a study design

 basedir = '/home/gareth/Documents/Fishing with the Flanker/UltimateFish/epochs/';
 
 subjs = {'3001'  '3007'    '9904'  '9950', ...
'3002'  '3008'    '9909'  '9952', ...
'3003'  '3009'    '9913'  '9954', ...
'3004'  '3011'   '9946'  '9955', ...
'3005'  '3015'   '9948', ...
'3006'  '3016'  '9902'  '9949', ...   
'4145'  '4177' '4190' '4146'  '4179'	'4191' '4162'  '4180'	'4192' '4167'  '4183' '4170'  '4186' '4195' '4171'  '4187'};
 
 commands = {}; % initialize STUDY dataset list
 
 % Now loop through subjects and add to the STUDY
 
 for subj = 1:length(subjs) % for each subject
    fileNoGO   = fullfile(basedir, subjs{subj}, strcat(subjs{subj},'_noGO.set'));
    fileIncongruous = fullfile(basedir, subjs{subj}, strcat(subjs{subj},'_incongruous.set'));
    fileCongruous   = fullfile(basedir, subjs{subj}, strcat(subjs{subj},'_congruous.set'));

    if subj > 23
        groupName = 'child';
    else
        groupName = 'adult';
    end;

    commands = { commands{:} ...
           {'index' 3*subj-2 'load' fileNoGO   'subject' subjs{subj} 'condition' 'NoGO' 'group' groupName } ...
           {'index' 3*subj-1 'load' fileIncongruous 'subject' subjs{subj} 'condition' 'Incongruous' 'group' groupName } ...
           {'index' 3*subj   'load' fileCongruous    'subject' subjs{subj} 'condition' 'Congruous' 'group' groupName } };
end;

commands = { commands{:} { 'dipselect', 0.15 } };

[STUDY ALLEEG] = std_editset( STUDY, ALLEEG, 'name', 'Flanker task', ...
     'task', 'Flanker', 'commands', commands, ...
     'updatedat','off', 'filename', fullfile(basedir, 'ULTIMATE FISH YOLO.study'));

% update workspace variables and redraw EEGLAB
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
[STUDY, ALLEEG] = std_checkset(STUDY, ALLEEG);
eeglab redraw;


%% Study analysis

% do some study analysis
[STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, 'components','recompute','on','scalp','on');
[STUDY ALLEEG] = std_preclust(STUDY, ALLEEG, 1,{'scalp' 'npca' 10 'norm' 1 'weight' 1 'abso' 1},{'dipoles' 'norm' 1 'weight' 10});
[STUDY] = pop_clust(STUDY, ALLEEG, 'algorithm','kmeans','clus_num',  18 );
[STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, {},'rmclust',[4 11 14 16 17] ,'interp','on','recompute','on','erp','on','erpparams',{'rmbase' [-200 0] });
