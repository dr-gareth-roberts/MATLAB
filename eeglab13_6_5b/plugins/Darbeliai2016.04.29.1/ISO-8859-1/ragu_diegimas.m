% 
% Pamginti parsisti ir diegti RAGU,
%
% (C) 2014 Mindaugas Baranauskas
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

url='http://www.thomaskoenig.ch/Ragu_src.zip';

rehash;

if ~(exist('Ragu.m','file') == 2) ;
    path__=fullfile(regexprep(which('eeglab.m'),'eeglab.m$','plugins'),'thomaskoenig' , 'Ragu' );
else
    path__=fullfile(regexprep(which('Ragu.m'),'Ragu.m$','')) ;
    path_deactivated=fullfile(regexprep(which('eeglab.m'),'eeglab.m$','deactivatedplugins') , 'Ragu' );
    try
        rmdir(path_deactivated, 's');
    catch err;
    end;
    %mkdir(path_deactivated);
    movefile(path__ , path_deactivated ) ;
end;

status = 0;
try
    mkdir(path__);
    disp('Parsiuniame Ragu...');
    [filestr,status] = urlwrite(url,fullfile(path__,'Ragu_src.zip')) ;
    
catch err ;
    disp(['Nepavyko parsisti RAGU. Galbt neturite teiss rayti  aplank ' path__ ]);
    try
        rmdir(path__, 's');
        movefile(path_deactivated, path__ ) ;
        addpath(path__); savepath ;
    catch err;
    end;
end;

if status == 1 ;
    try
        unzip(filestr,path__);
        delete(filestr);
        addpath(path__);
        addpath(regexprep(path__,'Ragu$',''));
        disp('Parsiuntme ir diegme RAGU');
        eeglab;
    catch err;
        disp('RAGU parsiuntme, bet nepavyko ipakuoti.');
        try
            rmdir(path__,'s');
            movefile(path_deactivated, path__ ) ;
            addpath(path__); savepath ;
        catch err;
        end;
    end;
    try
        savepath ;
    catch err;
        %disp('Bet turite rankiniu bdu isaugoti keli.');
    end;
else
    disp('Nepavyko parsisti RAGU. Galbt nra interneto ryio.');
    try
        rmdir(path__,'s');
        movefile(path_deactivated, path__ ) ;
        addpath(path__); savepath ;
    catch err;
    end;
end;

rehash toolbox;

