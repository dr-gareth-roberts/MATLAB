%%#########################################################################
% ERP Flanker Analysis
% Gareth Roberts - Murdoch University
%#########################################################################

clc; clear; close; eeglab

%% CONSTANTS
DATA_PATH = '/media/DATAPART1/Gareth/PKIDS Flanker/raw/'; %input..i.e, where the data files live
CHAN_LOCATIONS = '/home/gareth/matlab/toolbox/eeglab13_2_2b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp';
RESULTS_PATH = '/media/DATAPART1/Gareth/FlankerERN/';

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

            % filter - lower edge 0.1hz
            EEG  = pop_basicfilter( EEG,  1:40 , 'Cutoff', [ 0.1 30], 'Design', 'butter', 'Filter', 'bandpass', 'Order',2);
            
            %remove unused channels
            EEG = pop_select( EEG,'nochannel',{'VEOGL' 'VEOGU' 'CPZ-NC' 'X7-NC' 'X8-NC'});
             
            %reref the data
            EEG = pop_reref( EEG, [24 30] );
            
            EEG = pop_saveset( EEG,'filename',strcat(loadCnt(1:8),'_0_1_30'),'filepath',RESULTS_PATH);
            
    end;
%% part 2

% get everything ready (paths, eeglab, current directory, etc.)

DATA_PATH = '/media/DATAPART1/Gareth/FlankerNormal/part1/';
cd (DATA_PATH);
currentDir = (pwd);
RESULTS_PATH = '/media/DATAPART1/Gareth/FlankerBeh/sequence_effects/';

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
        EEG  = pop_binlister( EEG , 'BDF', '/media/DATAPART1/Gareth/flanker_bins2.txt','ExportEL', strcat('/media/DATAPART1/Gareth/FlankerBeh/sequence_effects/',char(loadSet(1:8)),'_seq_events.txt'),'IndexEL',  1, 'SendEL2', 'EEG&Text', 'UpdateEEG', 'on', 'Voutput', 'EEG' ); 
        EEG = pop_overwritevent( EEG, 'binlabel');
        values = pop_rt2text(EEG, 'eventlist',  1, 'filename', strcat('/media/DATAPART1/Gareth/FlankerBeh/sequence_effects/',char(loadSet(1:8)),'_seq_rts.txt'), 'header', 'on', 'listformat', 'basic' );


%          EEG = pop_epochbin( EEG , [-100.0  1000.0],  'pre');
% %         % do artefact rejection
% %         EEG  = pop_artextval( EEG , 'Channel',  1:33, 'Flag', 1, 'Threshold', [ -100 100], 'Twindow', [ -600 800] );
% % 
% %         %save file
%          ERP = pop_averager( EEG , 'Criterion', 'good', 'ExcludeBoundary', 'on', 'SEM', 'on' );
%          ERP = pop_savemyerp(ERP, 'erpname', char(loadSet(1:8)), 'filename',strcat(char(loadSet(1:8)),'.erp'), 'filepath', RESULTS_PATH, 'Warning', 'on');
%         % export RTs
%         values = pop_rt2text(EEG, 'eventlist',  1, 'filename', strcat('/media/DATAPART1/Gareth/FlankerBeh/correct_errors_all_trials/',char(loadSet(1:8)),'_rts.txt'), 'header', 'on', 'listformat', 'basic' );
    end;
    
    
