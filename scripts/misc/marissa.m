%%#########################################################################
% Flanker Analysis for Marissa
% Script organised into MATLAB cells to facilitate analysis.
% Complete analysis pipeline for AO study in MATLAB. Requires EEGLAB.
% Gareth Roberts, 2014. Murdoch University.
%#########################################################################

clc; clear; close; eeglab

% what to run
runICA = 0; % 0 = no, 1 = yes

%% CONSTANTS
DATA_PATH = '/media/DATAPART1/Gareth/Diabetes EEG/flanker/'; %input..i.e, where the data files live
CHAN_LOCATIONS = '/home/gareth/matlab/toolbox/eeglab13_2_2b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp';
RESULTS_PATH = '/media/DATAPART1/Honours/Marissa/part1/';

% Analysis Parameters
FILTER_LOWER_EDGE = 1;
FILTER_UPPER_EDGE = 30;
EPOCH_LENGTH = [-.1 .7];
BASELINE_CORRECTION = [-100 0];
REFERENCE = []; %average reference

% Part 1
% get everything ready (paths, eeglab, current directory, etc.)
cd (DATA_PATH);
currentDir = (DATA_PATH);

% get the files in the directory and count how many there are
cntFilesinDir=dir(fullfile(currentDir,'*.cnt'));
nCntFiles=length(cntFilesinDir);

%% Part 1 = load file, load chan locs, filter 1-30 Hz
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
        %remove unused channels
        EEG = pop_select( EEG,'nochannel',{'VEOGL' 'VEOGU' 'CPZ-NC' 'X7-NC' 'X8-NC'});
        %reref the data
        EEG = pop_reref( EEG, [24 30] );
        %epoching
        EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString',...
        { 'boundary' } );
        EEG = pop_overwritevent( EEG, 'code');
        EEG  = pop_binlister( EEG , 'BDF', '/media/DATAPART1/Honours/Mel/bins_flanker_mel.txt', 'IndexEL',  1, 'SendEL2', 'EEG', 'UpdateEEG', 'on', 'Voutput', 'EEG' ); 
        EEG = pop_overwritevent( EEG, 'binlabel');
        stimTimePeriod = EPOCH_LENGTH;
        stimBaselinePeriod = BASELINE_CORRECTION;
        EEG = pop_epoch( EEG, {  'B1(1O)'  'B1(2)'  'B2(3)'  'B2(4)'  'B3(5)'  'B3(6)'  'B5(3)'  'B5(4)'  'B6(5)'  }, stimTimePeriod);
        %baseline correction
        EEG = pop_rmbase( EEG, [-100    0]);       
        %extreme value rej
         EEG = pop_eegthresh(EEG,1,[1:33] ,-150,150,-0.1,0.696,0,1);
        %run ICA
        if runICA == 1
            %run ICA
            EEG = pop_runica(EEG, 'extended',1,'interupt','on');
            %dipole fitting
            EEG = pop_dipfit_settings( EEG, 'hdmfile','/home/gareth/matlab/toolbox/eeglab13_2_2b/plugins/dipfit2.3/standard_BEM/standard_vol.mat','coordformat','MNI','mrifile','/home/gareth/matlab/toolbox/eeglab13_2_2b/plugins/dipfit2.3/standard_BEM/standard_mri.mat','chanfile','/home/gareth/matlab/toolbox/eeglab13_2_2b/plugins/dipfit2.3/standard_BEM/elec/standard_1005.elc','coord_transform',[0.69007 -16.5752 2.2667 0.088341 0.0023112 -1.5742 1.1807 1.0693 1.1509] ,'chansel',[1:33] );
            EEG = pop_multifit(EEG, [1:33] ,'threshold',100,'rmout','on','dipplot','on','plotopt',{'normlen' 'on'});
        end;
        %save file
        rerefname = strcat(loadCnt,'_part1.set');
        finalLoc = strcat(RESULTS_PATH,rerefname);
        strFinalLoc = char(rerefname);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',strFinalLoc,'overwrite','on','gui','off');   
        EEG = pop_saveset( EEG, 'filename',strFinalLoc,'filepath','/media/DATAPART1/Honours/Marissa/part1/');
    end;
    %% Separate epochs
    datapath = '/media/DATAPART1/Honours/Marissa/part1/';
    resultspath = '/media/DATAPART1/Honours/Marissa/part2/';

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
            
            % create congruous epochs
            EEG = pop_epoch( EEG, { 'B1(1)'  'B1(2)' }, EPOCH_LENGTH, 'newname', 'congruous', 'epochinfo', 'yes');
            EEG = pop_rmbase( EEG, BASELINE_CORRECTION);
            EEG = pop_saveset( EEG,'filename',strcat(loadSet(1:4),'_congruous'),'filepath',subjectDir);
            EEG = pop_loadset('filename',setLocation);
            
            % create incongrous epochs
            EEG = pop_epoch( EEG, {  'B2(3)'  'B2(4)'  }, EPOCH_LENGTH, 'newname', 'incongruous', 'epochinfo', 'yes');
            EEG = pop_rmbase( EEG, BASELINE_CORRECTION);
            EEG = pop_saveset( EEG,'filename',strcat(loadSet(1:4),'_incongruous'),'filepath',subjectDir);
            EEG = pop_loadset('filename',setLocation);
            
            % create noGO epochs
            EEG = pop_epoch( EEG, {  'B3(5)'  'B3(6)' }, EPOCH_LENGTH, 'newname', 'switch', 'epochinfo', 'yes');
            EEG = pop_rmbase( EEG, BASELINE_CORRECTION);
            EEG = pop_saveset( EEG,'filename',strcat(loadSet(1:4),'_switch'),'filepath',subjectDir);
            EEG = pop_loadset('filename',setLocation);
     end;

%% Create a study design

 basedir = '/media/DATAPART1/Honours/Marissa/part2/';
 
 subjs = {'4000'  '4003'  '4007'  '4012'	'4016'  '4019'  '4022'  '4026'	'4033'  '4037'  '4042'  '4046'	'4052'  '4056'  '4060'  '4068',...
'4001'  '4004'  '4010'  '4014'	'4017'  '4020'  '4023'  '4027'	'4034'  '4040'  '4043'  '4048'	'4053'  '4058'  '4064'  '4069',...
'4002'  '4006'  '4011'  '4015'	'4018'  '4021'  '4024'  '4029'	'4036'  '4041'  '4045'  '4049'	'4054'  '4059'  '4066'  '4070'};
 
 commands = {}; % initialize STUDY dataset list
 
 % Now loop through subjects and add to the STUDY
 for subj = 1:length(subjs) % for each subject
    fileNoGO   = fullfile(basedir, subjs{subj}, strcat(subjs{subj},'_switch.set'));
    fileIncongruous = fullfile(basedir, subjs{subj}, strcat(subjs{subj},'_incongruous.set'));
    fileCongruous   = fullfile(basedir, subjs{subj}, strcat(subjs{subj},'_congruous.set'));
   
    
    if subj > 40 % CHANGE VALUE HERE - this is where to change subject information. i.e. prem or typical
        groupName = 'diabetic';
    else
        groupName = 'typical';
    end;

           
    commands = { commands{:} ...
           {'index' 3*subj-2 'load' fileNoGO   'subject' subjs{subj} 'condition' 'Switch' 'group' groupName } ...
           {'index' 3*subj-1 'load' fileIncongruous 'subject' subjs{subj} 'condition' 'Incongruous' 'group' groupName } ...
           {'index' 3*subj   'load' fileCongruous    'subject' subjs{subj} 'condition' 'Congruous' 'group' groupName } };
end;



commands = { commands{:} { 'dipselect', 0.15 } };
[STUDY ALLEEG] = std_editset( STUDY, ALLEEG, 'name', 'Flanker task', ...
     'task', 'Flanker', 'commands', commands, ...
     'updatedat','off', 'filename', fullfile(basedir, 'marissa honours.study'));

% update workspace variables and redraw EEGLAB
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
[STUDY, ALLEEG] = std_checkset(STUDY, ALLEEG);
eeglab redraw;

%% do some study analysis
[STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, 'components','recompute','on','scalp','on');
[STUDY ALLEEG] = std_preclust(STUDY, ALLEEG, 1,{'scalp' 'npca' 10 'norm' 1 'weight' 1 'abso' 1},{'dipoles' 'norm' 1 'weight' 10});
[STUDY] = pop_clust(STUDY, ALLEEG, 'algorithm','kmeans','clus_num',  18 );
[STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, {},'rmclust',[4 11 14 16 17] ,'interp','on','recompute','on','erp','on','erpparams',{'rmbase' [-200 0] });
[STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, 'components','recompute','on','spec','on','specparams',{'specmode' 'fft' 'logtrials' 'off'},'ersp','on','erspparams',{'cycles' [2 0.5]  'freqs' [5 30]  'nfreqs' 200},'itc','on');
[STUDY EEG] = pop_savestudy( STUDY, EEG, 'savemode','resave');
