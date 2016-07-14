% eegplugin_pvaftopo()
% 
% Usage:
%   >> eegplugin_pvaftopo(fig,try_strings,catch_strings);
%
%   see also: pop_pvaftopo, pvaftopo

% History:
% 02/27/2014 ver 0.10 by Makoto. Created.

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
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

function eegplugin_pvaftopo(fig,try_strings,catch_strings)

% create menu
toolsmenu = findobj(fig, 'tag', 'plot');
uimenu( toolsmenu, 'label', 'pvaf topo', 'separator','on','callback', 'EEG = pop_pvaftopo(EEG);');