% Compute a time-frequency decomposition for every electrode

for dataset = 1:5

[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, (dataset + 1),'retrieve',dataset,'study',0); 

for elec = 1:5
	[ersp,itc,powbase,times,freqs] = pop_newtimef( EEG, 1, 9, [-200  996], [0] ,...
        'freqs',[1 30],'topovec', elec, 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo,...
        'caption', 'FZ', 'baseline',[-200 0],'basenorm','on', 'padratio', 16,...
        'winsize', 50,'plotersp','off', 'plotitc','off');
    
	if elec == 1  % create empty arrays if first electrode
		allersp = zeros([ size(ersp) 5]);
		allitc = zeros([ size(itc) 5]);
		allpowbase = zeros([ size(powbase) 5]);
		alltimes = zeros([ size(times) 5]);
		allfreqs = zeros([ size(freqs) 5]);
	end;
	allersp (elec,:,:,:) = ersp;
	allitc (elec,:,:,:) = itc;
	allpowbase (ele:,:,elec) = powbase;
	alltimes (:,:,elec) = times;
	allfreqs (:,:,elec) = freqs;
end;
end;
% Plot a tftopo() figure summarizing all the time/frequency transforms
figure;
tftopo(allersp,alltimes(:,:,5),allfreqs(:,:,5),'mode','ave','timefreqs', ... 
[200 20; 600 6], 'chanlocs', EEG.chanlocs);

%% connectivity
figure; pop_newcrossf( EEG, 1, 7, 30, [-200  996], [0.5 3] ,'type',...
'phasecoher', 'topovec', [7  30], 'elocs', EEG.chanlocs, 'chaninfo',...
EEG.chaninfo, 'title','Channel FCZ-PZ Phase Coherence','padratio', 16,...
'freqs',[1 30],'subitc','off');
