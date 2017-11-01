%%script for averagering RT data

%get a list of all txt files in the directory
fileNames = dir(fullfile('*.txt'));         %get all the .cnt files
ntxtFiles = length(fileNames);     

%loop through them
for textfile = 2:ntxtFiles
    import_rt(fileNames(textfile).name)
   
    cong_left_rr_(textfile,1) = nanmean(ans(1:length(ans),1));
    cong_right_rr_(textfile,1) = nanmean(ans(1:length(ans),2));
    incong_left_rr_(textfile,1) = nanmean(ans(1:length(ans),3));
    incong_right_rr_(textfile,1) = nanmean(ans(1:length(ans),4));
    reverse_left_rr_(textfile,1) = nanmean(ans(1:length(ans),5));
    reverse_right_rr_(textfile,1) = nanmean(ans(1:length(ans),6));
    cong_left_rs_(textfile,1) = nanmean(ans(1:length(ans),7));
    cong_right_rs_(textfile,1) = nanmean(ans(1:length(ans),8));
    incong_left_rs_(textfile,1) = nanmean(ans(1:length(ans),9));
    incong_right_rs_(textfile,1) = nanmean(ans(1:length(ans),10));
    reverse_left_rs_(textfile,1) = nanmean(ans(1:length(ans),11));
    reverse_right_rs_(textfile,1) = nanmean(ans(1:length(ans),12));
end;

%%

%% script for accuracy data
%import textfile as <2000 x 3 cell>

subjCode = errorratesflankertask{1,3}(22:29);
cC = errorratesflankertask{2


for k = 1:length(errorratesflankertask)
    if strcmp(errorratesflankertask{(k),1},'bin') == 1
        subjData{(k),1} = errorratesflankertask{(k),3}(22:29); 
    else
        continue;
    end;
end;
    elseif strcmp(errorratesflankertask{(k),1},'(cC):') == 1
        cC{(k),1} = errorratesflankertask{(k),2};
    elseif strcmp(errorratesflankertask{(k),1},'(cI):') == 1
        cI{(k),1} = errorratesflankertask{(k),2};
    elseif strcmp(errorratesflankertask{(k),1},'(cS):') == 1
        cS{(k),1} = errorratesflankertask{(k),2};
    elseif strcmp(errorratesflankertask{(k),1},'(iI):') == 1
        iI{(k),1} = errorratesflankertask{(k),2};    
    elseif strcmp(errorratesflankertask{(k),1},'(iC):') == 1
        iC{(k),1} = errorratesflankertask{(k),2};
    elseif strcmp(errorratesflankertask{(k),1},'(iS):') == 1
        iS{(k),1} = errorratesflankertask{(k),2};       
    elseif strcmp(errorratesflankertask{(k),1},'(sS):') == 1
        sS{(k),1} = errorratesflankertask{(k),2};
    elseif strcmp(errorratesflankertask{(k),1},'(sC):') == 1
        sC{(k),1} = errorratesflankertask{(k),2};    
    end;  
end;
% get rid of empty values in subjCode list
subjList = subjCode(~cellfun('isempty',subjCode))';
cC_trials = cC(~cellfun('isempty',cC))';

        
        
        
