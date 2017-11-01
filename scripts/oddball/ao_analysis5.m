%%#########################################################################
% Auditory Oddball - EEG Analysis
% Script organised into MATLAB cells to facilitate analysis.
% Complete analysis pipeline for AO study in MATLAB. Requires EEGLAB.
% Gareth Roberts, 2013. Murdoch University.
%#########################################################################

%% CONSTANTS
DATA_PATH = 'C:\Users\20130929\Desktop\AO\';
CHAN_LOCATIONS = 'C:\Users\20130929\Documents\MATLAB\eeglab12_0_2_5b\plugins\dipfit2.2\standard_BESA\standard-10-5-cap385.elp';
EEGLAB_PATH =  'C:\Users\20130929\Documents\MATLAB\eeglab12_0_2_5b\';
RESULTS_PATH = 'C:\Users\20130929\Desktop\AO_part1\';

% Analysis Parameters
FILTER_LOWER_EDGE = 0.5;
FILTER_UPPER_EDGE = 30;
EPOCH_LENGTH = [-.1 .7];
BASELINE_CORRCTION = [-100 0];
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
       % EEG = pop_reref( EEG, [] );
        rerefname = strcat(loadCnt,'_reref.set');
        finalLoc = strcat(RESULTS_PATH,rerefname);
        strFinalLoc = char(finalLoc);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',strFinalLoc,'overwrite','on','gui','off'); 
    end; 
    
%% Part 2
% static locations
datapath = 'C:\Users\20130929\Desktop\AO_part1\';
resultspath = 'C:\Users\20130929\Desktop\AO_part2\';

% get everything ready (paths, eeglab, current directory, etc.)
    cd (datapath);
    currentDir = (datapath);
    
    setFilesinDir=dir(fullfile(currentDir,'*.set'));
    nSetFiles=length(setFilesinDir);
    stimCodes = {  '1'  '2'  '3'  '4'  '5'  '6'  '7'  '10'  '11' };
    stimTimePeriod = [-0.2           1];
    stimBaselinePeriod = [-200    0];

     % main file loop
     for setfile = 1:1%nSetFiles
            loadSet=(setFilesinDir(setfile).name);
            setLocation=strcat(currentDir,loadSet);
            % load set file
            EEG = pop_loadset('filename',setLocation);
            % filter - lower edge 1hz
            EEG = pop_eegfilt( EEG, 0.05, 0, [], [0], 0, 0, 'fir1', 0);
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
             EEG = pop_autorej(EEG, 'nogui','on','eegplot','off');
            % Save new epochs
            fileName = strcat(loadSet(1:5),'_all_epochs.set');
            EEG = pop_saveset( EEG,'filename',fileName,'filepath',resultspath);
     end;

%% part 3 - cut up the epochs
    datapath = 'C:\Users\20130929\Desktop\AO_part2\';
    resultspath = 'C:\Users\20130929\Desktop\AO_part3\';

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
            
            % create standards_equal epochs
            EEG = pop_epoch( EEG, {  '2'  }, EPOCH_LENGTH, 'newname', 'standards_equal', 'epochinfo', 'yes');
            EEG = pop_rmbase( EEG, BASELINE_CORRCTION);
            EEG = pop_saveset( EEG,'filename',strcat(loadSet(1:4),'_standards_equal'),'filepath',subjectDir);
            EEG = pop_loadset('filename',setLocation);
            
            % create targets epochs
            EEG = pop_epoch( EEG, {  '3'  }, EPOCH_LENGTH, 'newname', 'targets', 'epochinfo', 'yes');
            EEG = pop_rmbase( EEG, BASELINE_CORRCTION);
            EEG = pop_saveset( EEG,'filename',strcat(loadSet(1:4),'_targets'),'filepath',subjectDir);
            EEG = pop_loadset('filename',setLocation);
            
            % create novels epochs
            EEG = pop_epoch( EEG, {  '4' '5' '6' '7'  }, EPOCH_LENGTH, 'newname', 'novels', 'epochinfo', 'yes');
            EEG = pop_rmbase( EEG, BASELINE_CORRCTION);
            EEG = pop_saveset( EEG,'filename',strcat(loadSet(1:4),'_novels'),'filepath',subjectDir);
            EEG = pop_loadset('filename',setLocation);
     end;
   

%% part 4 - Create a study design
eeglab
basedir = 'C:\Users\20130929\Desktop\AO_part3\';

subjs = {'5025'	'5029'	'5031'	'5035'	'5037'	'5039'	'5047'	'5049'	'5051'	'5061'	'5063'	'5066'	'5073'	'5076'	'5081'	'5083'	'5085'...
'5027'	'5030'	'5034'	'5036'	'5038'	'5040'	'5048'	'5050'	'5060'	'5062'	'5064'	'5072'	'5074'	'5080'	'5082'	'5084'	'5086'};

commands = {}; % initialize STUDY dataset list

% Now loop through subjects and add to the STUDY
for subj = 1:length(subjs) % for each subject
    fileNovels   = fullfile(basedir, subjs{subj}, strcat(subjs{subj},'_novels.set'));
    fileTargets = fullfile(basedir, subjs{subj}, strcat(subjs{subj},'_targets.set'));
    fileStandards   = fullfile(basedir, subjs{subj}, strcat(subjs{subj},'_standards_equal.set'));
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

