%% Preprocess loop

clear;clc;
EEG = pop_loadbv();
EEG = pop_chanedit(EEG, 'lookup','/Users/g/Documents/MATLAB/eeglab14_0_0b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp');
EEG = pop_resample( EEG, 250);
EEG = pop_eegfiltnew(EEG, 0.5, 30);
EEG = pop_reref( EEG, []);
EEG = pop_saveset(EEG);