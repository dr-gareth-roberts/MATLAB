%% accuracy analysis

%get a list of all txt files in the directory
fileNames = dir(fullfile('*events.txt'));         %get all the .cnt files
ntxtFiles = length(fileNames);     

%loop through them
for textfile = 1:ntxtFiles
    getbinevents(fileNames(textfile).name)
    
    accData{textfile} = ans;
    subjects{textfile} = fileNames(textfile).name(1:8);
end;

% store accuracy results in a matrix for easy access
acc = zeros(194,6); %initialise matrix

for i = 1:194
    acc(i,1:6) = accData{1,i}(:)';
end;

% write output to excel file
xlswrite('acc_seq_data.xls',acc);


%% rt analysis

%get a list of all txt files in the directory
fileNames = dir(fullfile('*clean_rts.txt'));         
ntxtFiles = length(fileNames);     

%loop through them
for textfile = 1:ntxtFiles
    rt_import(fileNames(textfile).name)
   
    rts(textfile,1) = nanmean(ans(1:length(ans),1));
    rts(textfile,2) = nanmean(ans(1:length(ans),2));
    rts(textfile,3) = nanmean(ans(1:length(ans),3));
    rts(textfile,4) = nanmean(ans(1:length(ans),4));
    rts(textfile,5) = nanmean(ans(1:length(ans),5));
    rts(textfile,6) = nanmean(ans(1:length(ans),6));
end;

% write output to excel file
xlswrite('rt_normal_data.xls',rts);

