% eegplugin_darbeliai() 
% EEGLAB papildinys duomen rinkini apdorojimui patogioje grafinje aplinkoje.
%
%
% Pagrindins grafins ssajos programos:
% --
% <a href="matlab:helpwin pop_pervadinimas">pop_pervadinimas</a> - fail pervadinimui;
% <a href="matlab:helpwin pop_nuoseklus_apdorojimas">pop_nuoseklus_apdorojimas</a> - EEG apdorojimo darbai;
% <a href="matlab:helpwin pop_RRI_perziura">pop_RRI_perziura</a> - QRS laik, RRI kreivi, EKG perirjimas ir koregavimas;
% <a href="matlab:helpwin pop_Epochavimas_ir_atrinkimas">Epochavimas_ir_atrinkimas</a> - epochavimas su slyga, kad yra kito tipo vykis;
% <a href="matlab:helpwin pop_ERP_savybes">pop_ERP_savybes</a> - su vyki susijusi potencial (SSP) tyrinjimas;
%
%
% Kitos grafins ssajos programls:
% --
% <a href="matlab:helpwin konfig">konfig</a> - Darbeli atnaujinimo ir kalbos nuostatos; saugomos <a href="matlab:load Darbeliai_config.mat">Darbeliai_config.mat</a>;
% <a href="matlab:helpwin pop_atnaujinimas">pop_atnaujinimas</a> - atnaujinimo dialogas;
% <a href="matlab:helpwin pop_QRS_i_EEG">pop_QRS_i_EEG</a> - kardiograma elektroencefalogramoje;
%
%
% Pagalbins funkcijos, taiau paleistos be argument, paprays pasirinkti apdorotinus raus:
% --
% <a href="matlab:helpwin atmest_pg_amplit">atmest_pg_amplit</a> - artefakt (pavyzdi, mirksjimo akimis) atmetimui;
% <a href="matlab:helpwin Epochavimas_ir_atrinkimas7">Epochavimas_ir_atrinkimas7</a> -  j kreipiasi <a href="matlab:helpwin pop_Epochavimas_ir_atrinkimas">pop_Epochavimas_ir_atrinkimas</a>;
% <a href="matlab:helpwin eksportuoti_ragu_programai">eksportuoti_ragu_programai</a> - eksportuojant  Ragu naudojama <a href="matlab:load RaguMontage62.mat">RaguMontage62.mat</a> kanal schema;
%
%
% Kitos naudingos funkcijos:
% --
% <a href="matlab:helpwin lokaliz">lokaliz</a> - programlse matomo teksto vertimas; saugomas <a href="matlab:load lokaliz.mat">lokaliz.mat</a>;
% <a href="matlab:helpwin atnaujinimas">atnaujinimas</a> - EEGLAB papildini (numatytuoju atveju - Darbeli) diegimas/atnaujinimas;
% <a href="matlab:helpwin ragu_diegimas">ragu_diegimas</a> - EEGLAB skirto Ragu papildinio parsiuntimas  diegimas;
% <a href="matlab:helpwin EEG_spektr_galia">EEG_spektr_galia</a> - spektras, absoliuios ir santykins galios dani srityse;
% <a href="matlab:helpwin eeg_ivykiu_sarasas">eeg_ivykiu_sarasas</a> - ;
% <a href="matlab:helpwin eeg_kanalu_sarasas">eeg_kanalu_sarasas</a> - ;
% <a href="matlab:helpwin filter_filenames">filter_filenames</a> - rinkmen paieka; galina dirbti poaplankiuose;
% <a href="matlab:helpwin merge_cells">merge_cells</a> - lenteli, turini bendr antrai, apjungimui;
% <a href="matlab:helpwin Pranesk_apie_klaida">Pranesk_apie_klaida</a> - isamus spjimas po klaidos;
% <a href="matlab:helpwin Tikras_Kelias">Tikras_Kelias</a> - jei nurodytas kelias neegzistuoja - grina veikiamj;
% <a href="matlab:helpwin atrinkti_teksta">atrinkti_teksta</a> - ;
% <a href="matlab:helpwin anotac_surinkti">anotac_surinkti</a> - ;
% <a href="matlab:helpwin ERP_savybes">ERP_savybes</a> - atlieka dal <a href="matlab:helpwin pop_ERP_savybes">pop_ERP_savybes</a> darbo;
% <a href="matlab:helpwin labchartEKGevent2eeglab">labchartEKGevent2eeglab</a> - LabChart EKG vyki eksportavimas;
% <a href="matlab:helpwin QRS_is_EEG">QRS_is_EEG</a> - QRS aptikimas, kai EKG yra tarp EEG kanal;
% <a href="matlab:helpwin QRS_detekt">QRS_detekt</a> - QRS aptikimas signale (matlab kintamajame);
% <a href="matlab:helpwin QRS_detekt_DPI">QRS_detekt_DPI</a> - ;
% <a href="matlab:helpwin QRS_detekt_fMRIb">QRS_detekt_fMRIb</a> - ;
% <a href="matlab:helpwin QRS_detekt_mobd">QRS_detekt_mobd</a> - ;
% <a href="matlab:helpwin QRS_detekt_Pan_Tompkin">QRS_detekt_Pan_Tompkin</a> - ;
% <a href="matlab:helpwin convert_file_encoding">convert_file_encoding</a> - ;
% <a href="matlab:helpwin scrollplot2">scrollplot2</a> - truput modifikuota Yair M. Altman programa slinktukui;
%
%
% Pasenusios funkcijos:
% --
% <a href="matlab:helpwin pop_erp_area">pop_erp_area</a> - ERP plotas, pusplotis, minimumas, maksimumas; naudokite <a href="matlab:helpwin pop_ERP_savybes">pop_ERP_savybes</a>; 
% <a href="matlab:helpwin erp_area">erp_area</a> - atlieka dal <a href="matlab:helpwin pop_erp_area">pop_erp_area</a> darbo; naudokite <a href="matlab:helpwin ERP_savybes">ERP_savybes</a>;
% <a href="matlab:helpwin pop_naujas">pop_naujas</a> - ablonas naujoms grafinms funkcijoms;
% <a href="matlab:helpwin pop_atnaujinimas_">pop_atnaujinimas_</a> - supaprastesnis atnaujinimo dialogas nei <a href="matlab:helpwin pop_atnaujinimas">pop_atnaujinimas</a>;
%
%
% Kita:
% --
% *.fig - grafins ssajos objektai;
% <a href="matlab:helpwin _eegplugin_darbeliai">_eegplugin_darbeliai</a> - <a href="matlab:helpwin eegplugin_darbeliai">eegplugin_darbeliai</a> UTF-8 kopija;
% <a href="matlab:edit Darbeliai.versija">Darbeliai.versija</a> - Darbeli versijos numeris;
% <a href="matlab:edit LICENSE_GPL-3.0.txt">LICENSE_GPL-3.0.txt</a> - GNU vieoji licencija (treioji versija, angl kalba);
% <a href="matlab:helpwin darbeliu_istorija">darbeliu_istorija</a> - Programos pakeitimai. Kas nauja ioje versijoje?
%
%
% Galima pasirinkti lietuvi arba angl kalb. 
% Prisiderinama prie naudojamos koduots: 
% UTF-8 aplanko *.m rinkmenos konvertuojamos  sistemos koduot.
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
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% (C) 2014 Mindaugas Baranauskas   
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%

function vers = eegplugin_darbeliai(fig,try_strings,catch_strings)

curdir = [fileparts(which(mfilename)) filesep];
main_menu_name ='Darbeliai';
vers = 'Darbeliai v?';
config_file='Darbeliai_config.mat';
kelias=pwd;

try
   fid_vers=fopen(fullfile(curdir,'Darbeliai.versija'));
   vers=regexprep(regexprep(fgets(fid_vers),'[ ]*\n',''),'[ ]*\r','');
   fclose(fid_vers); 
catch err;
  disp(err.message);
end;

clear('lokaliz');

% EEGLAB klaida naudojant su  MATLAB R2015b: updatemenu:1398
warning('off','MATLAB:lang:cannotClearExecutingFunction');

% Pabandyti perkelti kitas ios programls versijas kitur
wb=warning('off','MATLAB:rmpath:DirNotFound');
rmpath(curdir);
if strcmp(curdir(1:(end-1)),pwd); cd('..') ; end;
rehash;
path_deactivated=[fileparts(which('eeglab')) filesep 'deactivatedplugins' filesep ];
rmpath(genpath(path_deactivated));
path_deactivated_i=length(path_deactivated) - 1;
if length(pwd) >= path_deactivated_i ;
   if strcmp(curdir(1:path_deactivated_i),path_deactivated(1:end-1));
      cd(fileparts(which('eeglab')));
   end;
end;
if length(curdir) >= path_deactivated_i;
   if strcmp(curdir(1:path_deactivated_i),path_deactivated(1:end-1));
      cd(fileparts(which('eeglab')));
      warning(wb.state,'MATLAB:rmpath:DirNotFound');
      return;
   end;
end;
[dublik,~,~]=fileparts(which(mfilename));
while ~isempty(dublik);
    rmpath(dublik);
    if ~(exist(path_deactivated,'dir') == 7); mkdir(path_deactivated); end;
    movefile(dublik,path_deactivated,'f');
    [dublik,~,~]=fileparts(which(mfilename));
end;
warning(wb.state,'MATLAB:rmpath:DirNotFound');
cd(kelias);
addpath(curdir);
addpath(genpath(fullfile(curdir, 'fig_dlg')));
addpath(genpath(fullfile(curdir, 'external')));
%rmpath( genpath(fullfile(curdir, 'seni')));
%rmpath( genpath(fullfile(curdir, 'kiti')));

%disp(feature('DefaultCharacterSet'));
%feature('DefaultCharacterSet','UTF-8');

% Unix - UTF-8
V= version('-release') ;
% For MATLAB R2010b or later:
if or(strcmp(V,'2010b'), str2num(V(1:end-1)) > 2010 ) ;
    ret = feature('locale');
    encoding = ret.encoding;
    % For MATLAB R2008a through R2010a:
elseif str2num(V(1:end-1)) >= 2008 ;
    ret = feature('locale');
    [~,r] = strtok(ret.ctype,'.');
    encoding = r(2:end);
else
    encoding = get(0,'language');
end;

if strcmp(curdir(end),filesep); 
   curdir=curdir(1:end-1);
end ;
curdir_sep=find(ismember(curdir,filesep));
curdir_parrent=curdir(1:curdir_sep(end));
if exist(fullfile(curdir_parrent, config_file),'file') == 2;
   try
      movefile(fullfile(curdir_parrent, config_file), fullfile(curdir, config_file), 'f');
   catch err;
   end;
end;
curdir=[curdir filesep];

Darbeliai_nuostatos.lokale={ '' ; '' ; '' ; } ;
Darbeliai_nuostatos.tikrinti_versija=1;
Darbeliai_nuostatos.diegti_auto=0;
Darbeliai_konfig_vers='?';
Darbeliai_nuostatos.stabili_versija=1;
Darbeliai_nuostatos.savita_versija=0;
Darbeliai_nuostatos.url_atnaujinimui='https://github.com/embar-/eeglab_darbeliai/archive/stable.zip';
Darbeliai_nuostatos.url_versijai='https://raw.githubusercontent.com/embar-/eeglab_darbeliai/stable/Darbeliai.versija';
Darbeliai_nuostatos.meniu_ragu=0;

try
   load(fullfile(curdir,config_file));
   Darbeliai_nuostatos.lokale=Darbeliai.nuostatos.lokale;
   Darbeliai_nuostatos.tikrinti_versija=Darbeliai.nuostatos.tikrinti_versija;
   Darbeliai_nuostatos.diegti_auto=Darbeliai.nuostatos.diegti_auto;
   Darbeliai_nuostatos.url_atnaujinimui=Darbeliai.nuostatos.url_atnaujinimui;
   Darbeliai_nuostatos.url_versijai=Darbeliai.nuostatos.url_versijai;
   Darbeliai_nuostatos.stabili_versija=Darbeliai.nuostatos.stabili_versija;
   Darbeliai_nuostatos.meniu_ragu=Darbeliai.nuostatos.meniu_ragu;
   Darbeliai_nuostatos.savita_versija=Darbeliai.nuostatos.savita_versija;
   Darbeliai_konfig_vers=Darbeliai.konfig_vers;
catch err;
   %disp(err.message);
end;
lc=Darbeliai_nuostatos.lokale;    
if ~isempty(lc{1});
   try java.util.Locale.setDefault(java.util.Locale(lc(1),lc(2),lc(3))); catch; end;
end;

%encoding='windows-1257';

utfdir=[curdir 'UTF-8' filesep ];
encdir=[curdir encoding filesep ];
olddir=[curdir '___' filesep ];

try 
    if ismember(path,olddir);
        rmpath(olddir);
    end;
catch err;
end;

% Pagrindiniame kataloge neturi bti rinkmen, dubliuojani utfdir kataloge esanias
% Files in utfdir should not dublicate main dir files (if any) 
if exist(utfdir,'dir') == 7;
    utf_f=dir([ utfdir '*.m' ]);
    utf_f_pav={utf_f.name};
    for fi=1:length(utf_f_pav);
        f=utf_f_pav{fi};
        if exist([curdir f ],'file') == 2;
            %disp([ ' ' f ' ' lokaliz('moving_file') ' ' lokaliz('into') olddir '...']);
            if ~(exist(olddir,'dir') == 7); 
                mkdir(olddir);
            end;
            movefile([curdir f ], [olddir f ], 'f');
        end;
    end;
end;

% Jei naudojama ne unikodo (UTF-8) koduot, konvertuoti unikodo failus
if strcmp(encoding,'UTF-8');
    if exist(utfdir,'dir') == 7;
        addpath(utfdir);
        f='eegplugin_darbeliai.m';
        if exist([utfdir  f ],'file') == 2;
            copyfile([utfdir f ],[utfdir '_' f ],'f');
            movefile([utfdir f ],[curdir f ],'f');
        end;
        if exist([utfdir [ '_' f ] ],'file') == 2;
            copyfile([utfdir '_' f ],[curdir f ],'f');
        end;
    end;    
else
    try
        if ismember(path,utfdir);
            rmpath(utfdir);
        end;
    catch err;
    end;
    if exist(encdir,'dir') == 7;
        addpath(encdir);
        f='eegplugin_darbeliai.m';
        if exist([encdir f ],'file') == 2;
            movefile([encdir f ],[curdir f ],'f');
        end;
    else
        if exist(utfdir,'dir') == 7;
            utf_f=dir([ utfdir '*.m' ]);
            utf_f_pav={utf_f.name};
            
            mkdir(encdir);
            for fi=1:length(utf_f_pav);
                f=utf_f_pav{fi};
                if exist([utfdir f ],'file') == 2;
                    disp([' ' f ' '  lokaliz('converting_file') ' ' lokaliz('into') ' ' encoding '...']);
                    convert_file_encoding([utfdir f ], [encdir f ], 'UTF-8', encoding );
                end;
            end;
            addpath(encdir);
            f='eegplugin_darbeliai.m';
            if exist([encdir f ],'file') == 2;
                movefile([encdir f ],[curdir f ],'f');
            end;
            if exist([encdir '_' f ],'file') == 2;
                movefile([encdir '_' f ],[curdir f ],'f');
            end;
        end;
    end;
end;

if and((exist('atnaujinimas.m','file') == 2),...
   and(~isempty(Darbeliai_nuostatos.url_versijai),...
       ~isempty(Darbeliai_nuostatos.url_atnaujinimui))) ;
       
   nauja_versija='';
   status=0;
   apie_vers='';
   
   if Darbeliai_nuostatos.tikrinti_versija ;
      disp([main_menu_name ': ' lokaliz('Checking for updates...')]);
      [filestr,status] = urlwrite(Darbeliai_nuostatos.url_versijai,fullfile(tempdir,'Darbeliai_versija1.txt'));
   end;
   if status
       convert_file_encoding(filestr, [filestr '~'], 'UTF-8', encoding );
       fid_nvers=fopen([filestr '~']);
       nauja_versija=regexprep(regexprep(fgets(fid_nvers),'[ ]*\n',''),'[ ]*\r','');
       %disp(size(nauja_versija));
       apie_vers_='';
       while ischar(apie_vers_);
           apie_vers=[apie_vers apie_vers_];
           apie_vers_ = fgets(fid_vers);
       end;
       fclose(fid_nvers); 
       try delete(filestr); catch; end;
       try delete([filestr '~']); catch; end;
   end;	
   
   if and(~isempty(nauja_versija),~strcmp(nauja_versija,vers));
      disp([lokaliz('Rasta nauja versija') ': ' nauja_versija]);
      url_atnaujinimui=Darbeliai_nuostatos.url_atnaujinimui;
      
      % Jei sutampa rasta versija su paskiausia per GIT ileista versija, naudoti pastarj
      try git_latest=github_darbeliu_versijos(1);
          [filestr,status] = urlwrite(git_latest.url_versijai,fullfile(tempdir,'Darbeliai_versija2.txt'));
          if status;
              convert_file_encoding(filestr, [filestr '~'], 'UTF-8', encoding );
              fid_nvers=fopen([filestr '~']);
              nauja_versija2=regexprep(regexprep(fgets(fid_nvers),'[ ]*\n',''),'[ ]*\r','');
              fclose(fid_nvers);
              try delete(filestr); catch; end;
              try delete([filestr '~']); catch; end;
              if strcmp(nauja_versija,nauja_versija2) ...
                 && isequal(Darbeliai_nuostatos.stabili_versija,git_latest.stabili_versija);
                  url_atnaujinimui=git_latest.url_atnaujinimui;
                  %apie_vers=git_latest.komentaras;
              end;
          end;
      catch
      end;
      
      disp(regexprep(apie_vers,'\r','')); disp(' ');
      if Darbeliai_nuostatos.diegti_auto;
          close([...
              findobj('-regexp','name','EEGLAB*')
              findobj('-regexp','name','konfig')]);
          clear functions;
          atnaujinimas(url_atnaujinimui) ;
          disp(' ');
          warning(lokaliz('Please ignore error afer EEGLAB error plugin update.'));
          figure;
          h=gcf;
          close(h);
          return;
      else
          h=gcf;
          %msgbox(Tekstas, lokaliz('Nauja versija'));
          pop_atnaujinimas([],vers,nauja_versija,apie_vers);          
          %disp([h gcf]);
          figure(h);
      end;
   end;     
   
end;

% Iekoti Ragu
if ~(exist('Ragu.m','file') == 2 ) ;
    eeglab_plugin_dir=([ fileparts(which('eeglab')) filesep 'plugins' filesep ]);
    
    gal_ragu=filter_filenames([eeglab_plugin_dir '*' filesep 'Ragu.m;']);
    if ~isempty(gal_ragu) ; addpath(fileparts(gal_ragu{1}));   end;
    
    gal_ragu=filter_filenames([eeglab_plugin_dir '*' filesep '*' filesep 'Ragu.m;']);
    if ~isempty(gal_ragu) ; 
        addpath(fileparts(gal_ragu{1}));   
        addpath([(fileparts(gal_ragu{1} )) filesep '..']);
    end;
end;

% Menu
on='startup:on;study:on';
W_MAIN = findobj('tag','EEGLAB');
darbeliai_m = uimenu( W_MAIN, 'label', main_menu_name, 'tag', 'darbeliai', 'userdata', on);

% Pamginti perkelti  priepaskutin pozicij
try
    nitems = get(darbeliai_m,'position');
    set(darbeliai_m,'position',nitems-1);
catch
    set(darbeliai_m,'position',nitems);
end

% Meniu turinys
param_prad=[ ...
    'try ; darbeliu_param={''pathin'',{EEG.filepath},''files'',{ALLEEG.filename}} ; darbeliu_params=struct(darbeliu_param{:}); catch err ; ' ...
    'try ; darbeliu_param={''pathin'',{EEG.filepath},''files'',{EEG.filename}}    ; darbeliu_params=struct(darbeliu_param{:}); catch err ; ' ...
    '      darbeliu_param={} ; end; end; '] ;
param_pab='(darbeliu_param{:}); ';
uimenu( darbeliai_m, 'Label', lokaliz('Pervadinimas su info suvedimu'), ...
        'Separator','off', 'userdata', on, 'Callback', ... 
        [param_prad 'pop_pervadinimas' param_pab ] );
uimenu( darbeliai_m, 'Label', lokaliz('Nuoseklus apdorojimas'), ...
        'Separator','off', 'userdata', on, 'Callback', ... 
        [param_prad 'pop_nuoseklus_apdorojimas' param_pab ] );
if strcmp(char(java.util.Locale.getDefault()),'lt_LT');
uimenu( darbeliai_m, 'Label', lokaliz('EEG + EKG'), ...
        'Separator','off', 'userdata', on, 'Callback', ... 
        [param_prad 'pop_QRS_i_EEG' param_pab ] );
end;
uimenu( darbeliai_m, 'Label', lokaliz('Epochavimas pg. stimulus ir atsakus'), ...
        'Separator','off', 'userdata', on, 'Callback', ...
        [param_prad 'pop_Epochavimas_ir_atrinkimas' param_pab ] );
uimenu( darbeliai_m, 'Label', lokaliz('ERP properties, export...'), ...
        'Separator','off', 'userdata', on, 'Callback', ...
        [param_prad 'pop_ERP_savybes' param_pab ] );
uimenu( darbeliai_m, 'Label', [ lokaliz('EEG spektras ir galia') '...' ], ...
        'Separator','off', 'userdata', on, 'Callback', ...
        [param_prad 'pop_eeg_spektrine_galia' param_pab ] );
uimenu( darbeliai_m, 'Label', lokaliz('Custom command') , ...
        'Separator','off', 'userdata', on, 'Callback', ...
        [param_prad 'pop_rankinis' param_pab ] );
uimenu( darbeliai_m, 'Label', lokaliz('Meta darbeliai...') , ...
        'Separator','on', 'userdata', on, 'Callback', ...
        [param_prad 'pop_meta_drb' param_pab ] );


if Darbeliai_nuostatos.meniu_ragu ;          
    if (exist('Ragu.m','file') == 2 ) ;          
        ragu_m = uimenu( darbeliai_m, 'Label', lokaliz('Ragu'), 'Separator','on', 'userdata', on);
    else
        Ragu_atnaujinimo_meniu_pavadinimas=lokaliz('Diegti Ragu');
        uimenu( darbeliai_m, 'Label', Ragu_atnaujinimo_meniu_pavadinimas, 'Separator','on', ...
            'foregroundcolor', 'b', 'userdata', on, 'Callback', ...
             'ragu_diegimas ;'  );		
    end;
end;

uimenu( darbeliai_m, 'Label', [lokaliz('Nuostatos') ' (kalba/language)'], ...
        'separator','on', 'userdata', on, 'callback', ...
         'konfig ;'  );


if and(exist('atnaujinimas.m','file') == 2,...
   and(~isempty(Darbeliai_nuostatos.url_versijai),...
       ~isempty(Darbeliai_nuostatos.url_atnaujinimui))) ;      
   if and(~isempty(nauja_versija),~strcmp(nauja_versija,vers));
      Atnaujinimo_meniu_pavadinimas=[lokaliz('Atnaujinti iki') ' ' strrep(nauja_versija,'Darbeliai ','')];
      Tekstas=[ lokaliz('Naudojate') ; vers '.' ; {' '} ];
      Tekstas=[ Tekstas ; lokaliz('Rasta nauja versija') ': ' ; [nauja_versija '.'] ];
      Tekstas=[ Tekstas ; ' ' ; lokaliz('Eikite meniu') ; main_menu_name ' -> ' Atnaujinimo_meniu_pavadinimas ;  ];
      Tekstas=[ Tekstas ; lokaliz('ir atnaujinkite papildin!') ] ;       
      h=gcf;
      %msgbox(Tekstas, lokaliz('Nauja versija'));
      uimenu( darbeliai_m, 'Label', Atnaujinimo_meniu_pavadinimas, ...
          'separator','off', 'userdata', on, ...
          'foregroundcolor', 'r', 'Callback', [ 'atnaujinimas ;' ] );
      figure(h);
   else
      Atnaujinimo_meniu_pavadinimas=lokaliz('Check for updates');
      uimenu( darbeliai_m, 'Label', Atnaujinimo_meniu_pavadinimas, ...
      'separator','off', 'userdata', on, 'foregroundcolor', 'b', ...
      'Callback',  'pop_atnaujinimas ;'  );    
   end;
end;


% Apie
LC_='';
try LC_=[lc(1) ' ' lc(2)]; catch; end;
try LC=javaObject ('java.util.Locale',''); LC_=LC.getDefault(); catch; end;
if strcmp(LC_,'lt_LT');
uimenu( darbeliai_m, 'Label',  [ lokaliz('Apie') ' ' vers ] , ...
          'separator','off', 'userdata', on, 'callback', ...
           'web(''https://github.com/embar-/eeglab_darbeliai/wiki/0.%20LT'',''-browser'') ;'  );
else
uimenu( darbeliai_m, 'Label',  [ lokaliz('Apie') ' ' vers ] , ...
          'separator','off', 'userdata', on, 'callback', ...
           'web(''https://github.com/embar-/eeglab_darbeliai/wiki/0.%20EN'',''-browser'') ;'  );           
end;


% RAGU meniu
if and(Darbeliai_nuostatos.meniu_ragu,(exist('Ragu.m','file') == 2 )) ;
%    uimenu( ragu_m, 'Label', lokaliz('Eksp Ragu'), ...
%    'Separator','on', 'userdata', on, 'Callback', ...
%         'eksportuoti_ragu_programai(ALLEEG, EEG, CURRENTSET) ;'  );
    uimenu( ragu_m, 'Label', lokaliz('Atverti Ragu'), ...
    'Separator','off', 'userdata', on, 'Callback', ...
             'Ragu ;'  );
    Ragu_atnaujinimo_meniu_pavadinimas=lokaliz('Bandyti atnaujinti Ragu');
    uimenu( ragu_m, 'Label', Ragu_atnaujinimo_meniu_pavadinimas, 'Separator','on', ...
        'foregroundcolor', 'b', 'userdata', on, 'Callback', ...
         'ragu_diegimas ;'  );		
end;

% Eksperimentin versija?
if ~Darbeliai_nuostatos.stabili_versija ;
    warning('off','backtrace');
    warning(sprintf( [ '\n' vers ' ' lokaliz('Trunk version') '!\n' ...
        lokaliz('Eikite meniu') ':\n'  main_menu_name ' -> ' ...
        lokaliz('Nuostatos') ' (kalba/language) -> '  lokaliz('Stable version') ] ));
    warning('on','backtrace');
end;

return;

% Svarbi informacija apie nauj versij
if ~strcmp(Darbeliai_konfig_vers,vers);
   Darbeliai.konfig_vers=vers;
   save(fullfile(curdir,'Darbeliai_config.mat'),'Darbeliai');
   h=gcf;
   msgbox(['Sugro meniu punktas duomen eksportavimui  RAGU; ' ...
   'bet geriau naudokite SSP savybi ir eksportavimo programl. ' ], ...
   vers);
   figure(h);
end;
