
% %% ERP export
% % static locations
% datapath = pwd;
% resultspath = pwd;
% 
% % get everything ready (paths, eeglab, current directory, etc.)
%     [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
%     cd (datapath);
%     currentDir = (datapath);
%    
%     setFilesinDir=dir(fullfile(currentDir,'*.set'));
%     nSetFiles=length(setFilesinDir);
%     
%      % main file loop
%      for setfile = 1:nSetFiles
%             loadSet=(setFilesinDir(setfile).name);
%             setLocation=strcat(currentDir,'/',loadSet);
%             % load set file
%             EEG = pop_loadset('filename',setLocation);           
%             % export erp data to .txt file in same directory
%             pop_export(EEG,strcat(pwd,'/',loadSet(1:6),'_erp'),'erp','on');
%      end;
