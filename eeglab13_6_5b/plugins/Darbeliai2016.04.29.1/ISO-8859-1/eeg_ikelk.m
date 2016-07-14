% eeg_ikelk - duomen klimas EEGLAB struktros pavidalu kone i bet
% kokios vienos EEG rinkmenos [EEG]=eeg_ikelk(kelias,rinkmena)

function [EEG]=eeg_ikelk(Kelias, Rinkmena)

    [Kelias_,Rinkmena_]=rinkmenos_tikslinimas(Kelias,Rinkmena);
    try % Importuoti kaip EEGLAB *.set
        EEG = pop_loadset('filename',Rinkmena_,'filepath',Kelias_);
    catch 
        Kelias_ir_rinkmena=fullfile(Kelias_, Rinkmena_);
        % Pranesk_apie_klaida(lasterr, mfilename, Kelias_ir_rinkmena, 0);
        fprintf('\n%s\n%s...\n', Kelias_ir_rinkmena, lokaliz('ne EEGLAB rinkmena'));
        try % Importuoti per BIOSIG
            fprintf('%s %s...\n', lokaliz('Trying again with'), 'BIOSIG');
            EEG=pop_biosig(Kelias_ir_rinkmena);
            EEG=eegh( ['pop_biosig(' Kelias_ir_rinkmena ')' ], EEG);
            if isempty(EEG.data); error(lokaliz('Empty dataset')); end;
        catch %; Pranesk_apie_klaida(lasterr, mfilename, Kelias_ir_rinkmena, 0);
            fprintf('%s...\n', lokaliz('BIOSIG negali nuskaityti'));
            try % Importuoti per FILEIO
                fprintf('%s %s...\n', lokaliz('Trying again with'), 'FILEIO');
                EEG=pop_fileio(Kelias_ir_rinkmena);
                EEG=eegh( ['pop_fileio(' Kelias_ir_rinkmena ')' ], EEG);
                % Sutvarkyti vyki pavadinimus
                try tipai=regexprep({EEG.event.type},'[\0]*$','');
                    [EEG.event.type]=tipai{:};
                catch
                end;
            catch %; Pranesk_apie_klaida(lasterr, mfilename, Kelias_ir_rinkmena, 0);
                fprintf('%s...\n', lokaliz('FILEIO negali nuskaityti'));
                try % kelti tiesiogiai  MATLAB
                    fprintf('%s %s...\n', lokaliz('Trying again with'), 'MATLAB');
                    load(Kelias_ir_rinkmena,'-mat');
                catch %; Pranesk_apie_klaida(lasterr, mfilename, Kelias_ir_rinkmena, 0);
                    fprintf('%s...\n', lokaliz('MATLAB negali nuskaityti'));
                    try % Bent tui EEGLAB EEG struktr pasilyti
                        [~, EEG] = pop_newset([],[],[]);
                    catch %; Pranesk_apie_klaida(lasterr, mfilename, Kelias_ir_rinkmena, 0);
                        % Belieka tui grinti...
                        EEG=[];
                    end;
                end;
            end;
        end;
    end;
    
    