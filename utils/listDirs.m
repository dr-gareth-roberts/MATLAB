function dirs = listDirs(pwd)
%listDirs
%super handy function to list the subdirectories of a directory as elements
%of a cell. can be used to quickly generate studies in EEGLAB
% Gareth Roberts, Murdoch University - 12/09/14.

% get a list of the directories
[status cmdout] = unix('ls -d */');

% convert the list into a cell format
 dirs=char2cell(cmdout,{'/'});
 
% remove the last element which is blanked
dirs(end) = [];
end

