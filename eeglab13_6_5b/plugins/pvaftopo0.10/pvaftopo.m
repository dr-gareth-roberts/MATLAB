% pvaftopo() - computes pvaf topography (Unit: percent).
%
% Input:
%        EEG:  EEGLAB variable EEG
%        IC:   Independent component numbers to compute pvaftopo
%
% Usage:
%        outTopo = pvaftopo(EEG, [1 4 6 8 15]);    % compute pvaftopo for IC1,4,6,8,and 15.
%
% see also: pop_pvaftopo, eegplugin_pvaftopo

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

function outTopo = pvaftopo(EEG, IC)

if nargin < 2 || isempty(IC); error('Enter IC number(s) to backproject.'); end

% compute pvaftopo
outTopo  = zeros(EEG.nbchan,length(IC));
backProj = EEG.icawinv(:,IC)*eeg_getdatact(EEG,'component',IC,'reshape','2d');
outTopo  = 100-100*var(EEG.data(:,:)-backProj,0,2)./var(EEG.data(:,:),0,2);