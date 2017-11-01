function [nFiles, fileList] = getFileList(location,filetype)
cd (location);

% get the files in the directory and count how many there are
fileList=dir(fullfile(location,filetype));
nFiles=length(fileList);
end 
