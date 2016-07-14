% [KELIAS,Rinkmena]=rinkmenos_tikslinimas(KELIAS,Rinkmena)

%
% (C) 2015 Mindaugas Baranauskas
%
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

function [KELIAS_,Rinkmena_]=rinkmenos_tikslinimas(KELIAS,Rinkmena)

    [KELIAS_,Rinkmena_,galune]=fileparts(Rinkmena);
    Rinkmena_=[Rinkmena_ galune];
    if isempty(KELIAS_);
        KELIAS_=Tikras_Kelias(KELIAS);
    elseif ~strcmp(pwd,KELIAS_);
        KELIAS_SUM=Tikras_Kelias(fullfile(KELIAS,KELIAS_));
        if ~strcmp(pwd,KELIAS_SUM);
            KELIAS_=KELIAS_SUM;
        else
            KELIAS_=Tikras_Kelias(KELIAS_);
        end;
    end;    