function vers = eegplugin_envtopoForContinuous(fig, try_strings, catch_strings)

vers = '0.10';

if nargin < 3
    error('eegplugin_groupSIFT requires 3 arguments');
end;

% create a highLevelMenu
highLevelManu = findobj(fig, 'tag', 'tools');
submenu       = uimenu(highLevelManu, 'label', 'Envtopo for Continuous','separator','on');

% add submenu
uimenu( submenu, 'label', 'Envtopo for Continuous', 'callback', 'pop_envtopoForContinuous');