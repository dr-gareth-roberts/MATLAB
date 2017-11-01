times = [0:100:500];
% Define variables: 
pos = eeg_lat2point(times/250, 1, EEG.srate, [EEG.xmin EEG.xmax]);
% Convert times to points (or >pos = round( (times/1000-EEG.xmin)/(EEG.xmax-EEG.xmin) * (EEG.pnts-1))+1;)
% See the event tutorial for more information on processing latencies
mean_data = mean(EEG.data(:,pos,:),3);
% Average over all trials in the desired time window (the third dimension of EEG.data allows to access different data trials).
% See appendix A1 for more information
maxlim = max(mean_data(:));
minlim = min(mean_data(:));
% Get the data range for scaling the map colors.
maplimits = [ -max(maxlim, -minlim) max(maxlim, -minlim)];
% Plot the scalp map series.
figure
for k = 1:6
sbplot(2,3,k);
% A more flexible version of subplot.
topoplot( mean_data(:,k), EEG.chanlocs, 'maplimits', maplimits, 'electrodes', 'on', 'style', 'both');
title([ num2str(times(k)) ' ms']);
end
cbar; 
