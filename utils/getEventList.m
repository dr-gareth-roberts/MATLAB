function getEventList( eventfile, exportfile )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
        EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString',...
        { 'boundary' } );
        EEG = pop_overwritevent( EEG, 'code');
        EEG  = pop_binlister( EEG , 'BDF',eventfile,  'ExportEL', exportfile, 'IndexEL',  1, 'SendEL2', 'EEG&Text', 'UpdateEEG', 'on', 'Voutput', 'EEG' ); 
        EEG = pop_overwritevent( EEG, 'binlabel');
end
