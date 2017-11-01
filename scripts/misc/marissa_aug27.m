%%#########################################################################
% ERP Flanker Analysis
% Gareth Roberts - Murdoch University
%#########################################################################

clc; clear; close; eeglab


%% CONSTANTS
DATA_PATH = '/media/DATAPART1/Gareth/Diabetes EEG/flanker/'; %input..i.e, where the data files live
CHAN_LOCATIONS = '/home/gareth/matlab/toolbox/eeglab13_2_2b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp';
RESULTS_PATH = '/media/DATAPART1/Honours/Marissa/new1/';

% Part 1
% get everything ready (paths, eeglab, current directory, etc.)
cd (DATA_PATH);
currentDir = (DATA_PATH);

% get the files in the directory and count how many there are
cntFilesinDir=dir(fullfile(currentDir,'*.cnt'));
nCntFiles=length(cntFilesinDir);

%% Part 1 = load file, load chan locs, filter 1-30 Hz
    for cntfile = 63:nCntFiles %62 crashed
        loadCnt=(cntFilesinDir(cntfile).name);
        cntLocation=strcat(currentDir,loadCnt);
        EEG = pop_loadcnt(cntLocation, 'dataformat', 'auto'); 
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',loadCnt,'gui','off'); 
        EEG=pop_chanedit(EEG, 'lookup',CHAN_LOCATIONS);
        % filter - 0.1 to 30 Hz
        EEG  = pop_basicfilter( EEG,  1:40 , 'Cutoff', [ 0.1 30], 'Design', 'butter', 'Filter', 'bandpass', 'Order',2);
        %remove unused channels
        EEG = pop_select( EEG,'nochannel',{'VEOGL' 'VEOGU' 'CPZ-NC' 'X7-NC' 'X8-NC'});
        %reref the data
        EEG = pop_reref( EEG, [24 30] );
        %epoching
        EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString',...
        { 'boundary' } );
        EEG = pop_overwritevent( EEG, 'code');
        EEG  = pop_binlister( EEG , 'BDF', '/media/DATAPART1/Honours/Marissa/flanker_bins.txt', 'ExportEL', strcat(char(loadCnt(1:4)),'_events.txt'), 'IndexEL',  1, 'SendEL2', 'EEG&Text', 'UpdateEEG', 'on', 'Voutput', 'EEG' ); 
        EEG = pop_overwritevent( EEG, 'binlabel');
        EEG = pop_epochbin( EEG , [-100.0  600.0],  'pre');
        % do artefact rejection
        EEG  = pop_artextval( EEG , 'Channel',  1:33, 'Flag', 1, 'Threshold', [ -90 90], 'Twindow', [ -100 596] );
        EEG  = pop_artmwppth( EEG , 'Channel',  1:33, 'Flag',  1, 'Threshold',  100, 'Twindow', [ -100 596], 'Windowsize',  200, 'Windowstep',50);
        EEG  = pop_artstep( EEG , 'Channel',  1:33, 'Flag',  1, 'Threshold',  100, 'Twindow', [ -100 596], 'Windowsize',  200, 'Windowstep',50);
        %save file
        ERP = pop_averager( EEG , 'Criterion', 'good', 'ExcludeBoundary', 'on', 'SEM', 'on' );
        ERP = pop_savemyerp(ERP, 'erpname', char(loadCnt(1:4)), 'filename',strcat(char(loadCnt(1:4)),'.erp'), 'filepath', RESULTS_PATH, 'Warning', 'on');
        % export RTs
        values = pop_rt2text(ERP, 'eventlist',  1, 'filename', strcat(char(loadCnt(1:4)),'_rts.txt'), 'header', 'on', 'listformat', 'basic' );
    end;
