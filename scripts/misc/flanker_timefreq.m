%%#########################################################################
% Flanker Time-frequency Analysis
% Script organised into MATLAB cells to facilitate analysis.
% Complete analysis pipeline for AO study in MATLAB. Requires EEGLAB.
% Gareth Roberts, 2014. Murdoch University.
%#########################################################################

%% CONSTANTS
DATA_PATH = 'C:\Users\20130929\Desktop\unpublished adult flanker\cnt\';
CHAN_LOCATIONS = 'C:\Users\20130929\Documents\MATLAB\EEGLAB\plugins\dipfit2.3\standard_BESA\standard-10-5-cap385.elp';
EEGLAB_PATH =  'C:\Users\20130929\Documents\MATLAB\EEGLAB\';
RESULTS_PATH = 'C:\Users\20130929\Desktop\unpublished adult flanker\cnt\part1\';

% Analysis Parameters
FILTER_LOWER_EDGE = 1;
FILTER_UPPER_EDGE = 30;
EPOCH_LENGTH = [-.2 1];
BASELINE_CORRCTION = [-200 0];
REFERENCE = []; %average reference

%% Part 1
% get everything ready (paths, eeglab, current directory, etc.)
addpath(genpath(EEGLAB_PATH));
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
cd (DATA_PATH);
currentDir = (DATA_PATH);

% get the files in the directory and count how many there are
cntFilesinDir=dir(fullfile(currentDir,'*.cnt'));
nCntFiles=length(cntFilesinDir);

%convert to .set file
    for cntfile = 1:nCntFiles
        loadCnt=(cntFilesinDir(cntfile).name);
        cntLocation=strcat(currentDir,loadCnt);
        EEG = pop_loadcnt(cntLocation, 'dataformat', 'auto'); 
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',loadCnt,'gui','off'); 
        EEG=pop_chanedit(EEG, 'lookup',CHAN_LOCATIONS);
        [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
        EEG = eeg_checkset( EEG );
        EEG = pop_reref( EEG, [] );
        rerefname = strcat(loadCnt,'_reref.set');
        finalLoc = strcat(RESULTS_PATH,rerefname);
        strFinalLoc = char(finalLoc);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',strFinalLoc,'overwrite','on','gui','off'); 
    end; 
    
%% Part 2
% static locations
datapath = 'C:\Users\20130929\Desktop\unpublished adult flanker\cnt\part1\';
resultspath = 'C:\Users\20130929\Desktop\unpublished adult flanker\cnt\part2\';

% get everything ready (paths, eeglab, current directory, etc.)
    cd (datapath);
    currentDir = (datapath);
    
    setFilesinDir=dir(fullfile(currentDir,'*.set'));
    nSetFiles=length(setFilesinDir);
    stimCodes = {  '1'  '2'  '3'  '4'  '5'  '6' };
    stimTimePeriod = [-0.2           1];
    stimBaselinePeriod = [-200    0];

     % main file loop
     for setfile = 2:nSetFiles
            loadSet=(setFilesinDir(setfile).name);
            setLocation=strcat(currentDir,loadSet);
            % load set file
            EEG = pop_loadset('filename',setLocation);
            % filter - lower edge 1hz
            EEG = pop_eegfilt( EEG, 1, 0, [], [0], 0, 0, 'fir1', 0);
            % filter - higher edge 30hz
            EEG = pop_eegfilt( EEG, 0, 30, [], [0], 0, 0, 'fir1', 0);
            % Create all epochs
             EEG = pop_epoch( EEG, stimCodes, stimTimePeriod, 'newname', strcat(setfile,'_allepochs', 'epochinfo', 'yes'));
            % Remove baseline
             EEG = pop_rmbase( EEG,stimBaselinePeriod);
            % remove unnecessary channels
            EEG = pop_select( EEG,'nochannel',{'VEOGL' 'VEOGU' 'CPZ-NC' 'X7-NC' 'X8-NC'});
            % reference to average electrodes
            EEG = pop_reref( EEG, [] );
            % artefact rejection
%            EEG = eegthresh(EEG,1,[1:33] ,-100,100,-0.2,0.996,0,1);
            EEG = pop_autorej(EEG, 'nogui','on','threshold',500,'startprob',4,'maxrej',6);
            %run ICA
            EEG = pop_runica(EEG, 'extended',1,'interupt','on');
            %dipole fitting
            EEG = pop_dipfit_settings( EEG, 'hdmfile','C:\\Users\\20130929\\Documents\\MATLAB\\EEGLAB\\plugins\\dipfit2.3\\standard_BEM\\standard_vol.mat','coordformat','MNI','mrifile','C:\\Users\\20130929\\Documents\\MATLAB\\EEGLAB\\plugins\\dipfit2.3\\standard_BEM\\standard_mri.mat','chanfile','C:\\Users\\20130929\\Documents\\MATLAB\\EEGLAB\\plugins\\dipfit2.3\\standard_BEM\\elec\\standard_1005.elc','coord_transform',[0.83215 -15.6287 2.4114 0.081214 0.00093739 -1.5732 1.1742 1.0601 1.1485] ,'chansel',[1:35] );
            EEG = pop_multifit(EEG, [1:35] ,'threshold',30,'rmout','on','dipplot','off','plotopt',{'normlen' 'on'});
           % EEG = pop_autorej(EEG, 'nogui','on','eegplot','off');
            % Save new epochs
            fileName = strcat(loadSet(1:5),'_all_epochs.set');
            EEG = pop_saveset( EEG,'filename',fileName,'filepath',resultspath);
     end;

%% part 3 - cut up the epochs
    datapath = 'C:\Users\20130929\Desktop\unpublished adult flanker\cnt\part2\';
    resultspath = 'C:\Users\20130929\Desktop\unpublished adult flanker\cnt\part3\';

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
            subjectDir = strcat(resultspath,subjectName,'\');
            
            % load set file
            EEG = pop_loadset('filename',setLocation);
            
            % create congruous epochs
            EEG = pop_epoch( EEG, { '1' '2' }, EPOCH_LENGTH, 'newname', 'congruous', 'epochinfo', 'yes');
            EEG = pop_rmbase( EEG, BASELINE_CORRCTION);
            EEG = pop_saveset( EEG,'filename',strcat(loadSet(1:4),'_congruous'),'filepath',subjectDir);
            EEG = pop_loadset('filename',setLocation);
            
            % create incongrous epochs
            EEG = pop_epoch( EEG, {  '3' '4'  }, EPOCH_LENGTH, 'newname', 'incongruous', 'epochinfo', 'yes');
            EEG = pop_rmbase( EEG, BASELINE_CORRCTION);
            EEG = pop_saveset( EEG,'filename',strcat(loadSet(1:4),'_incongruous'),'filepath',subjectDir);
            EEG = pop_loadset('filename',setLocation);
            
            % create noGO epochs
            EEG = pop_epoch( EEG, {  '5' '6' }, EPOCH_LENGTH, 'newname', 'noGO', 'epochinfo', 'yes');
            EEG = pop_rmbase( EEG, BASELINE_CORRCTION);
            EEG = pop_saveset( EEG,'filename',strcat(loadSet(1:4),'_noGO'),'filepath',subjectDir);
            EEG = pop_loadset('filename',setLocation);
     end;
   

%% part 4 - Create a study design
eeglab
basedir = 'C:\Users\20130929\Desktop\unpublished adult flanker\cnt\part3\';

subjs = {'3003'  '3007'  '3015'  '9909'  '9949'  '9955'  '3004'  '3008'  '3016'  '9913'  '9950'  '3001'  '3005'  '3009'  '9902'  '9946'  '9952'  '3002'  '3006'  '3011'  '9904'  '9948'  '9954'  };

commands = {}; % initialize STUDY dataset list

% Now loop through subjects and add to the STUDY
for subj = 1:length(subjs) % for each subject
    fileNoGO   = fullfile(basedir, subjs{subj}, strcat(subjs{subj},'_noGO.set'));
    fileIncongruous = fullfile(basedir, subjs{subj}, strcat(subjs{subj},'_incongruous.set'));
    fileCongruous   = fullfile(basedir, subjs{subj}, strcat(subjs{subj},'_congruous.set'));
    commands = { commands{:} ...
           {'index' 3*subj-2 'load' fileNoGO   'subject' subjs{subj} 'condition' 'NoGO' } ...
           {'index' 3*subj-1 'load' fileIncongruous 'subject' subjs{subj} 'condition' 'Incongruous' } ...
           {'index' 3*subj   'load' fileCongruous    'subject' subjs{subj} 'condition' 'Congruous' } };
end;
commands = { commands{:} { 'dipselect', 0.15 } };
[STUDY ALLEEG] = std_editset( STUDY, ALLEEG, 'name', 'Flanker task', ...
     'task', 'Flanker', 'commands', commands, ...
     'updatedat','off', 'filename', fullfile(basedir, 'Flanker 1st Draft.study'));

% update workspace variables and redraw EEGLAB
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
[STUDY, ALLEEG] = std_checkset(STUDY, ALLEEG);
eeglab redraw;

%% part 5 - Compute some measures (ERPs, spectra, time-frequency, etc.)
%create ERPs
[STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, {},'interp','on','recompute','on','erp','on','erpparams',{'rmbase' [-200 0] });

%% ERP export
% static locations
datapath = pwd;
resultspath = pwd;

% get everything ready (paths, eeglab, current directory, etc.)
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    cd (datapath);
    currentDir = (datapath);
   
    setFilesinDir=dir(fullfile(currentDir,'*.set'));
    nSetFiles=length(setFilesinDir);
    
     % main file loop
     for setfile = 1:nSetFiles
            loadSet=(setFilesinDir(setfile).name);
            setLocation=strcat(currentDir,'/',loadSet);
            % load set file
            EEG = pop_loadset('filename',setLocation);           
            % export erp data to .txt file in same directory
            pop_export(EEG,strcat(pwd,'/',loadSet(1:6),'_erp'),'erp','on');
     end;

