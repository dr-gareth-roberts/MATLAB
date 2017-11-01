%%#########################################################################
% ERP Flanker Analysis
% Gareth Roberts - Murdoch University
%#########################################################################

clc; clear; close; eeglab

%% CONSTANTS
DATA_PATH = '/Users/Gareth/Documents/Academic Work/PKIDS EEG data/'; %input..i.e, where the data files live
CHAN_LOCATIONS = '/home/gareth/matlab/toolbox/eeglab13_2_2b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp';
RESULTS_PATH = '/Users/Gareth/Documents/Academic Work/PKIDS EEG data/';
ERP_PATH = RESULTS_PATH

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
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',loadCnt,'gui','off'); %         EEG=pop_chanedit(EEG, 'lookup',CHAN_LOCATIONS);
        %epoching
        EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString',...
        { 'boundary' } );
        EEG = pop_overwritevent( EEG, 'code');
        EEG  = pop_binlister( EEG , 'BDF', [RESULTS_PATH 'flanker_rr.txt'], 'ExportEL', strcat('/Users/Gareth/Documents/Academic Work/PKIDS EEG data/events/',char(loadCnt(1:8)),'_events.txt'), 'IndexEL',  1, 'SendEL2', 'EEG&Text', 'UpdateEEG', 'on', 'Voutput', 'EEG' ); 
             EEG = pop_overwritevent( EEG, 'binlabel');
             % save file
              EEG = pop_saveset( EEG,'filename',strcat(loadCnt(1:8),'_events'),'filepath',RESULTS_PATH);
%             %filter
             EEG  = pop_basicfilter( EEG,  1:40 , 'Cutoff', [ 0.5 30], 'Design', 'butter', 'Filter', 'bandpass', 'Order',2);
%             %remove unused channels
             EEG = pop_select( EEG,'nochannel',{'CPZ-NC' 'X7-NC' 'X8-NC'});
%         %reref the data
%         EEG = pop_reref( EEG, [24 30] );
         EEG = pop_epochbin( EEG , [-200.0  1000.0],  'pre');
%         % do artefact rejection
         EEG  = pop_artextval( EEG , 'Channel',  3:35, 'Flag', 1, 'Threshold', [ -135 135], 'Twindow', [ -200 996] );
%         EEG  = pop_artmwppth( EEG , 'Channel',  1:33, 'Flag',  1, 'Threshold',  115, 'Twindow', [ -200 996], 'Windowsize',  200, 'Windowstep',100);
%         EEG  = pop_artstep( EEG , 'Channel',  1:33, 'Flag',  1, 'Threshold',  115, 'Twindow', [ -200 996], 'Windowsize',  200, 'Windowstep',100);
        %save file
        ERP = pop_averager( EEG , 'Criterion', 'good', 'ExcludeBoundary', 'on', 'SEM', 'on' );
        ERP = pop_savemyerp(ERP, 'erpname', char(loadCnt(1:8)), 'filename',strcat(char(loadCnt(1:8)),'.erp'), 'filepath', ERP_PATH, 'Warning', 'on');
        % export RTs
        values = pop_rt2text(ERP, 'eventlist',  1, 'filename', strcat('/Users/Gareth/Documents/Academic Work/PKIDS EEG data/rt/',char(loadCnt(1:8)),'_rts.txt'), 'header', 'on', 'listformat', 'basic' );
    end;
%% part 2
% get everything ready (paths, eeglab, current directory, etc.)

DATA_PATH = '/Users/Gareth/Documents/Academic Work/FlankerSeq/setFiles/';
cd (DATA_PATH);
currentDir = (pwd);
RESULTS_PATH = '/Users/Gareth/Documents/Academic Work/Flanker2/';

% get the files in the directory and count how many there are
 setFilesinDir=dir(fullfile(currentDir,'*.set'));
 nSetFiles=length(setFilesinDir);

    for setfile = 1:nSetFiles
        loadSet=(setFilesinDir(setfile).name);
        setLocation=strcat(currentDir,'/',loadSet);
        EEG = pop_loadset(setLocation);
        % filter - 0.1 to 30 Hz
        EEG  = pop_basicfilter( EEG,  1:40 , 'Cutoff', [ 0.5 30], 'Design', 'butter', 'Filter', 'bandpass', 'Order',2);
        %remove unused channels
        EEG = pop_select( EEG,'nochannel',{'VEOGL' 'VEOGU' 'CPZ-NC' 'X7-NC' 'X8-NC'});
        %reref the data
        EEG = pop_reref( EEG, [24 30] );
        EEG = pop_epochbin( EEG , [-200.0  1000.0],  'pre');
        % do artefact rejection
        EEG  = pop_artextval( EEG , 'Channel',  1:33, 'Flag', 1, 'Threshold', [ -135 135], 'Twindow', [ -200 996] );
        %save file
        ERP = pop_averager( EEG , 'Criterion', 'good', 'ExcludeBoundary', 'on', 'SEM', 'on' );
        ERP = pop_savemyerp(ERP, 'erpname', char(loadSet(1:8)), 'filename',strcat(char(loadSet(1:8)),'.erp'), 'filepath', RESULTS_PATH, 'Warning', 'on');
        % export RTs
        values = pop_rt2text(ERP, 'eventlist',  1, 'filename', strcat('/Users/Gareth/Documents/Academic Work/PKIDS EEG data/rt/',char(loadSet(1:8)),'_rts.txt'), 'header', 'on', 'listformat', 'basic' );
    end;
    
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
    
    
