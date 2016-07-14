% eksportuoti_ragu_programai()
% eksportuoti_ragu_programai(ALLEEG, EEG)
%
% EEG eksportavimas  tekstin fail RAGU programai
%
%
% (C) 2014-2016 Mindaugas Baranauskas
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% i programa yra laisva. Js galite j platinti ir/arba modifikuoti
% remdamiesi Free Software Foundation paskelbtomis GNU Bendrosios
% Vieosios licencijos slygomis: 2 licencijos versija, arba (savo
% nuoira) bet kuria vlesne versija.
%
% i programa platinama su viltimi, kad ji bus naudinga, bet BE JOKIOS
% GARANTIJOS; be jokios numanomos PERKAMUMO ar TINKAMUMO KONKRETIEMS
% TIKSLAMS garantijos. irkite GNU Bendrj Viej licencij nordami
% suinoti smulkmenas.
%
% Js turjote kartu su ia programa gauti ir GNU Bendrosios Vieosios
% licencijos kopija; jei ne - raykite Free Software Foundation, Inc., 59
% Temple Place - Suite 330, Boston, MA 02111-1307, USA.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%
%%
 
function eksportuoti_ragu_programai(varargin)
 
if nargin > 0;    
    ALLEEG=varargin{1};
else
    ALLEEG = [];
end;
if nargin > 1;    
    EEG=varargin{2};
else
    EEG=[];
end;
if nargin > 2;    
    CURRENTSET=varargin{3};
else
    CURRENTSET=[];
end;
if nargin > 3;    
    Neklausti_failu=varargin{4};
else
    Neklausti_failu=0;
end;
if nargin > 4;    
    folder_name=varargin{5};
else
    folder_name='';
end;
if nargin > 5;    
    Reikalingi_kanalai=varargin{6};
else
    Reikalingi_kanalai={};
end;
 
 
disp(' ');
disp(' === EEG eksportavimas  tekstin fail RAGU programai ===');
 
% turi bti paleista EEGLAB programa
%eeglab redraw;

try    load(which('RaguMontage62.mat'));
catch
    warning('Nepavyko rasti RaguMontage62.mat');
    return;
end;
Channel62=Channel; %#ok - imporuotuojama i RaguMontage62.mat
Channel=struct('DataUnit', {}, 'Name', {}, 'RefName', {}, 'CoordsPhi', {}, 'CoordsRadius', {}, 'CoordsTheta', {}, 'UnitString', {}, 'ChannelColor', {});
VISI_KANALAI_62={Channel62.Name};
%{'Fp1' 'Fpz' 'Fp2' 'F7' 'F3' 'Fz' 'F4' 'F8' 'FC5' 'FC1' 'FC2' 'FC6' 'T7' ...
% 'C3' 'Cz' 'C4' 'T8' 'CP5' 'CP1' 'CP2' 'CP6' 'P7' 'P3' 'Pz' 'P4' 'P8' 'POz' ...
% 'O1' 'Oz' 'O2' 'AF7' 'AF3' 'AF4' 'AF8' 'F5' 'F1' 'F2' 'F6' 'FC3' 'FCz' 'FC4' ...
% 'C5' 'C1' 'C2' 'C6' 'CP3' 'CPz' 'CP4' 'P5' 'P1' 'P2' 'P6' ... 
% 'PO5' 'PO3' 'PO4' 'PO6' 'FT7' 'FT8' 'TP7' 'TP8' 'PO7' 'PO8' ;};
EEG_filenames={};
precision=7;

% Duomen klimas
button='Atverti naujus';
if ~isempty(EEG);
    try
        EEG(1).data=EEG(1).erp_data; % EEG.erp_data is not standard EEGLAB param
    catch err;
    end;
    if ~isempty(EEG(1).data);
        if ~Neklausti_failu;
            button = questdlg(['Kokius epochuotus duomenis naudoti?' ] , ...
                'Naudotini duomenys', ...
                'Atsisakyti', 'Jau keltuosius', 'Atverti naujus', 'Jau keltuosius');
        else
            button='Jau keltuosius';
        end;
    end;
end;
if strcmp(button,'Atsisakyti');
    return ;
end;
if strcmp(button,'Atverti naujus');
    [FileNames,PathName] = uigetfile({'*.set','EEGLAB EEG duomenys';'*.*','Visi failai'},'Pasirinkite duomenis','','MultiSelect','on');
    try     cd(PathName); catch; return ; end ;
    if class(FileNames) == 'char' ;
        NumberOfFiles=1 ;
        temp{1}=FileNames ;
        FileNames=temp;
    end ;
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    EEG = pop_loadset('filename',FileNames,'loadmode','info');
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    %eeglab redraw;
    EEG_filenames=FileNames;
end;
 
% Jei paymtas tik vienas rinkinys, pamginti kelti visus rinkinius
if and(length(EEG) == 1, length(ALLEEG) > 1);
    try
        [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'retrieve',[1:length(ALLEEG)] ,'study',0);
    catch %err; Pranesk_apie_klaida(err,'','',0);
        %eeglab redraw;
    end;
end;

% Tikrinti pasirinkt ra suderinamum, jei j yra keli
disp(' ');
disp('Tikrinami duomenys...');
if length(ALLEEG) > 1 ;
    if ~isequal(ALLEEG.srate) ;
        msg='Skiriasi duomen kvantavimo danis! Duomen suvienodinimui galite pasinaudoti tam skirta funkcija per meniu Tools > Change sampling rate';
        warning(msg);
        warndlg(msg, 'Duomenys nesuderinami!' );
        return ;
    end;
    if ~isequal(ALLEEG.pnts) ;
        msg=['Skiriasi EEG ra trukms! Trukmi suvienodinimui galite pasinaudoti tam skirta funkcija per meniu Darbeliai > Nuoseklus apdorojimas' ];
        warning(msg);
        warndlg(msg, 'Duomenys nesuderinami!' );
        return ;
    end;   
    if ~isequal(ALLEEG.nbchan) ;
        msg='EEG rauose skirtingas kanal kiekis! Kanal atrinkimui galite pasinaudoti tam skirta funkcija per meniu Darbeliai > Nuoseklus apdorojimas';
        warning(msg);
        warndlg(msg, 'Duomenys nesuderinami!' );
        return ;
    end;
    ChanLocs={};
    for i=1:length(ALLEEG);  
        ChanLocs(i,1:length({ALLEEG(1).chanlocs.labels}))={ALLEEG(i).chanlocs.labels};
    end;
    ChanLocsUniq=unique(ChanLocs)';
    for i=1:size(ChanLocs,1);  
        if ~isequal(ChanLocsUniq,unique(ChanLocs(i,:)));
            msg='EEG rauose nesutampa kanalai! Kanal suvienodinimui galite pasinaudoti kanal atrinkimo funkcija per meniu Darbeliai > Nuoseklus apdorojimas';
            warning(msg);
            warndlg(msg, 'Duomenys nesuderinami!' );
            return ;
        end;
    end;
    Svetimi_kanalai=setdiff(upper(ChanLocsUniq),intersect(upper(VISI_KANALAI_62),upper(ChanLocsUniq)));
    if ~isempty(Svetimi_kanalai) ;
        %msg=['Kanalai, kurie neturi atitikmens Ragu schemoje: ' Svetimi_kanalai 'Kanal atrinkimui galite pasinaudoti tam skirta funkcija ' 'per meniu Darbeliai > Nuoseklus apdorojimas' ] ;
        msg=['Kai kurie kanalai neturi atitikmens Ragu schemoje: '  Svetimi_kanalai  'Jie nebus eksportuojami.' ] ;
        disp(char(msg));
        warndlg(msg, 'Nepageidaujami kanalai!' );
        %return ;
    end;
%     min_trials = 0;
%     if ~isequal(EEG.trials) ;
%         msg=['Skiriasi epoch kiekis! ' ];
%         disp(msg);
%        
%         min_trials=min([EEG.trials]);
%   
%         button = questdlg(['Skiriasi epoch kiekis!' [{}] ...
%            [ 'Min: ' num2str(min_trials) ] ...
%            [ 'Max: ' num2str(max([EEG.trials])) ] ...
%            [ 'Ar suvienodinti epoch kiek, visuose ' ] ...
%            [ 'duomesyse paliekant tik pirmas ' num2str(min_trials) '?'] ]  , ...
%            'Duomenys nesuderinami!', ...
%            'Atsisakyti', 'Nevienodinti','Suvienodinti', 'Suvienodinti');  
%
%          if strcmp(button,'Nevienodinti');
%              min_trials = 0;
%          end;
%       
%        if strcmp(button,'Atsisakyti');
%              disp('Ataukta!');
%            % feature('DefaultCharacterSet',koduote);
%              return ;
%          end;
%     end; 
elseif length(ALLEEG) == 1 ;
    ChanLocs={};
    ChanLocs(1,1:length({ALLEEG(1).chanlocs.labels}))={ALLEEG(1).chanlocs.labels};
    ChanLocsUniq=unique(ChanLocs)';
    Svetimi_kanalai=setdiff(upper(ChanLocsUniq),intersect(upper(VISI_KANALAI_62),upper(ChanLocsUniq)));
    if ~isempty(Svetimi_kanalai) ;
        %msg=['Kanalai, kurie neturi atitikmens Ragu schemoje: ' Svetimi_kanalai 'Kanal atrinkimui galite pasinaudoti tam skirta funkcija ' 'per meniu Darbeliai > Nuoseklus apdorojimas' ] ;
        msg=['Kai kurie kanalai neturi atitikmens Ragu schemoje: ' Svetimi_kanalai 'Jie nebus eksportuojami.' ] ;
        disp(char(msg));
        warndlg(msg, 'Nepageidaujami kanalai!' );
        %return ;
    end;
end;

% Kanal struktra
EEGLAB_ChanLocs=EEG(1).chanlocs;
for i=1:length(EEGLAB_ChanLocs);
   try
      Channel(1+length(Channel))=Channel62(find(ismember(upper([{Channel62.Name}]),upper(EEGLAB_ChanLocs(i).labels))));
   catch
      msg=['Bus praleistas kanalas: ' EEGLAB_ChanLocs(i).labels ] ;
      disp(msg);
      %warndlg(msg,'Nepilna schema');
   end;
end;
ChanLocs={Channel.Name};
ChN=length(Channel);

% Raymo formatas
strprintf = '';
for index = 1:ChN;
    strprintf = [ strprintf '%.' num2str(precision) 'f\t' ];
end;
strprintf(end) = 'n';


% Paklausti, kur saugoti duomenis
try
    if isempty(folder_name);
    folder_name = uigetdir(pwd, 'Pasirinkite aplank,  kur eksportuoti EEG duomenis tekstiniu pavidalu') ;
    end;
    new_folder=fullfile(folder_name, 'info');
    if ~isequal(exist(new_folder,'dir'),7);
        try mkdir(new_folder); catch; end;
    end;
    %cd(folder_name) ;
    disp(' ');
    disp('Duomenys bus raomi :');
    disp(folder_name);
catch
    disp('Ataukta!');
    return ;
end;
 
 
 
% Eksportavimas pai EEG duomen
disp(' ');
disp('Eksportuojama...');
Eksportuotos_rinkmenos={};
for i=1:length(ALLEEG) ;
    try
        EEG=ALLEEG(i);
        if ~isnumeric(EEG.data);
            EEG=eeg_retrieve(ALLEEG, i);
            %[~, EEG, ~] = pop_newset(ALLEEG, EEG, i,'retrieve',i,'study',0);
            %[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'retrieve',[1:length(ALLEEG)],'study',0);
        end;
        if length(EEG_filenames)<i;
            if ~isempty(EEG.filename);              
                EEG_filenames{i}=EEG.filename;       
            elseif ~isempty(EEG.setname);
                EEG_filenames{i}=EEG.setname;
            else
                EEG_filenames{i}=num2str(i);
            end;
        end;
       
        Rinkmena=[regexprep(EEG_filenames{i}, '.set$', '') '.txt'];
        Rinkmena_su_keliu=fullfile(folder_name, Rinkmena) ;
        disp([num2str(i) '/' num2str(length(ALLEEG)) ' (' num2str(round(i/length(ALLEEG) * 100)) '%): ' Rinkmena_su_keliu]);
        %if ~isempty(Svetimi_kanalai) ;
       
        try
            EEG.data=EEG.erp_data; % EEG.erp_data is not standard EEGLAB param
            EEG.trials=1; EEG.epoch=[]; EEG.event=[];
            EEG.icaact=[]; EEG.icawinv=[]; EEG.icasphere=[]; EEG.icaweights=[]; EEG.icachansind=[]; 
            disp(lokaliz('We use pre-processed data to speed up exporting data. Please ignore these eeg_checkset warnings:'));
            %lango_erp=[EEGTMP.erp_data(:,idx1:idx2,:)];
        catch 
            %lango_erp=mean([EEGTMP.data(:,idx1:idx2,:)],3);
        end;
       
        if isempty(EEG.data);
            error(lokaliz('Empty dataset'));
        end;
        
        TMPEEG = pop_select(EEG,'channel',ChanLocs);
        %end;
        %     if min_trials > 0 ;
        %        EEG = pop_selectevent( EEG, 'epoch',[1:min_trials] ,'deleteevents','off', 'deleteepochs','on', 'invertepochs','off');
        %     end;
        
%         if ~isempty(TMPEEG.epoch); % TMPEEG.trials > 0 ; % size(TMPEEG.data,3) >1 %
%             pop_export(TMPEEG, Rinkmena, 'transpose','on','elec','on','time','off','erp','on','precision',7);
%         else
%             pop_export(TMPEEG, Rinkmena, 'transpose','on','elec','on','time','off','erp','off','precision',7);
%         end;        
        
        x = TMPEEG.data;
        if ~isempty(TMPEEG.epoch); % TMPEEG.trials > 0 ; % size(TMPEEG.data,3) >1 %
            x = mean(x, 3);
        else
            x = reshape(x, size(x,1), size(x,2)*size(x,3));
        end;
        lentele=nan(ChN,size(x,2));
        x_n = size(x,1);
        for index = 1:x_n;
            lbl=TMPEEG.chanlocs(index).labels;
            nr=find(ismember(ChanLocs,lbl));
            % disp({index lbl '>' nr});
            if length(nr) == 1;
                lentele(nr,:)=x(index,:);
            else
                warning(lbl);
            end;
        end;
        
        fid = fopen(Rinkmena_su_keliu, 'w');
        fprintf(fid, strprintf, lentele);
        fclose(fid);
        
        Eksportuotos_rinkmenos{end+1}=Rinkmena;
        
    catch err;
        Pranesk_apie_klaida(err,'','',0);
    end;
end;
%[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'retrieve',[1:length(ALLEEG)],'study',0);
 
Info.srate=EEG(1).srate ;
Info.pnts=EEG(1).pnts ;
Info.trials=EEG(1).trials ;
Info.xmin=EEG(1).xmin ;
Info.xmax=EEG(1).xmax ;
 
disp(' ');
disp(['Delta X = ' num2str(1000 / Info.srate ) ' ms']);
disp(' ');
 
 
% Eksportavimas kanal padi srao
disp(' ');
disp('Eksportuojama kanal schema...');
 
%Kanalu_schemos_kelias=fullfile( pwd, [ '_' num2str(ChN) '_kan_padetys_' datestr(now, 'yyyy-mm-dd_HHMMSS') '.mat' ] ) ;
Kanalu_schemos_kelias=fullfile( folder_name, 'info' , [ 'Schema_' num2str(ChN) '.mat' ] ) ;
save(Kanalu_schemos_kelias ,'Channel', 'EEGLAB_ChanLocs', 'Info');
 
info_file=fullfile (folder_name, 'info', ['Ragu_duomenu_'  datestr(now, 'yyyy-mm-dd_HHMMSS') '.txt']);
finfo_id = fopen(info_file, 'w');
fprintf(finfo_id, [ datestr(now, 'yyyy-mm-dd HH:MM:SS') ' \n\n' ] );
fprintf(finfo_id, ['Sampling rate = ' num2str(Info.srate) ' Hz \n' ] );
fprintf(finfo_id, ['Time start    = ' num2str(Info.xmin) ' s \n' ] );
fprintf(finfo_id, ['Time end      = ' num2str(Info.xmax) ' s \n' ] );
fprintf(finfo_id, ['Delta X       = %0.4f ms \n' ] , (1000 / Info.srate ) );
fprintf(finfo_id, ['Schema        =\n%s\n\n%d :\n' ], Kanalu_schemos_kelias , ChN );
fprintf(finfo_id, ['%s ' ], Channel.Name );
fprintf(finfo_id, ['\n\n\n%s\n\n' ], [ folder_name filesep ] );
for i=1:length(Eksportuotos_rinkmenos) ;
    if (exist(fullfile(folder_name,Eksportuotos_rinkmenos{i})) == 2);
        fprintf(finfo_id, [ '%s \n' ], Eksportuotos_rinkmenos{i} );
    end;
end;
fclose(finfo_id);
try
    open(info_file);
catch err;
    disp(err.message);
end;
 
disp(' ');
disp('Kanal schem rasite');
disp(Kanalu_schemos_kelias);
disp(' ');
disp('Atlikta!');
disp(' ');
 
 
 
if and(~(exist('Ragu.m','file') == 2) , (exist('ragu_diegimas.m','file') == 2) );
 
      button = questdlg('Ar nortumte diegti Ragu?' , ...
           'RAGU programa nerasta!', ...
           'Atsisakyti', 'Diegti','Diegti');  
 
         if strcmp(button,'Diegti');
             try
                ragu_diegimas;
             catch
                msg=['Klaida bandant diegti Ragu.' ];
                disp(msg);
                warndlg(msg, 'Ragu diegimas' );
                return ;
             end
         end;
end;
 
if (exist('Ragu.m','file') == 2) ;
 
      button = questdlg('Atverti Ragu?'  , ...
           'Ar norite atverti RAGU?', ...
           'Atsisakyti', 'Atverti','Atverti');  
 
         if strcmp(button,'Atverti');
             try
                Ragu;
             catch
                msg='Klaida bandant atverti Ragu.';
                disp(msg);
                warndlg(msg, 'Atverti Ragu' );
                return ;
             end
         end;
end;

