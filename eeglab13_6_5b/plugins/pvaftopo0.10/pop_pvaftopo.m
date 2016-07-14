% pop_pvaftopo() - wrapper for pvaftopo()
%
% see also: eegplugin_pvaftopo, pvaftopo

% History:
% 02/27/2014 ver 0.10 by Makoto Created.

% Copyright (C) 2014, Makoto Miyakoshi, Scott Makeig. SCCN, INC, UCSD.
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1.07  USA

function [EEG,outTopo] = pop_pvaftopo(EEG)

userInput = inputgui('title', 'pop_pvaftopo()', 'geom', ...
   {{2 1 [0 0] [1 1]} {2 2 [1 0] [1 1]} ...
    {1 1 [0 1] [1 1]} ...
    {4 2 [0 3] [1 1]}},...
    'uilist', ...
   {{ 'style' 'text' 'string' 'Enter IC number(s) to backproject' } { 'style' 'edit' 'string' '' } ...
    { 'style' 'text' 'string' 'Note: This process requires channel infomation and ICA results.' } ...
    { 'style', 'pushbutton', 'string', 'Help', 'callback', 'pophelp(''pvaftopo'');'}});

IC = str2double(userInput{1,1});
outTopo = pvaftopo(EEG, IC);

figure
topoplot(outTopo, EEG.chanlocs);
title(['Percent variance accounted for by IC ' num2str(IC)], 'FontSize', 14);
caxisMax = max(outTopo);
cb = colorbar;
set(cb, 'ylim', [0 caxisMax]);
set(gcf, 'Name', 'pop_pvaftopo()', 'NumberTitle', 'off');

com = sprintf('outTopo = pvaftopo(EEG, [ %s ]);', userInput{1,1});
EEG = eegh(com, EEG);
disp('Done.')
