function varargout = pop_envtopoForContinuous(varargin)
% POP_ENVTOPOFORCONTINUOUS MATLAB code for pop_envtopoForContinuous.fig
%      POP_ENVTOPOFORCONTINUOUS, by itself, creates a new POP_ENVTOPOFORCONTINUOUS or raises the existing
%      singleton*.
%
%      H = POP_ENVTOPOFORCONTINUOUS returns the handle to a new POP_ENVTOPOFORCONTINUOUS or the handle to
%      the existing singleton*.
%
%      POP_ENVTOPOFORCONTINUOUS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POP_ENVTOPOFORCONTINUOUS.M with the given input arguments.
%
%      POP_ENVTOPOFORCONTINUOUS('Property','Value',...) creates a new POP_ENVTOPOFORCONTINUOUS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_envtopoForContinuous_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_envtopoForContinuous_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_envtopoForContinuous

% Last Modified by GUIDE v2.5 29-Feb-2016 17:54:25

% History
% 02/29/2016 Makoto. Created.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_envtopoForContinuous_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_envtopoForContinuous_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before pop_envtopoForContinuous is made visible.
function pop_envtopoForContinuous_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_envtopoForContinuous (see VARARGIN)

% Choose default command line output for pop_envtopoForContinuous
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pop_envtopoForContinuous wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pop_envtopoForContinuous_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function icIdxEdit_Callback(hObject, eventdata, handles)
% hObject    handle to icIdxEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of icIdxEdit as text
%        str2double(get(hObject,'String')) returns contents of icIdxEdit as a double

% import EEG
EEG = evalin('base', 'EEG');

% obtain IC index
icIdx = str2double(get(handles.icIdxEdit, 'String'));

% check input
if any(icIdx<1 | icIdx>size(EEG.icaweights,1))
    disp('IC index out of range: use 1.')
    set(handles.icIdxEdit, 'String', '1')
    icIdx = str2double(get(handles.icIdxEdit, 'String'));
end

% clear dipole axes
cla(handles.axialAxes,    'reset')
cla(handles.sagittalAxes, 'reset')
cla(handles.coronalAxes,  'reset')

% select sources
sources = EEG.dipfit;
sources.model = sources.model(1,icIdx);

% plot axial, sagittal, coronal
axes(handles.axialAxes);
dipplot(sources.model, 'dipolesize', 40, 'projlines', 'off', 'spheres', 'on', 'gui', 'off', 'normlen', 'on');
view([0 90]);
axes(handles.sagittalAxes);
dipplot(sources.model, 'dipolesize', 40, 'projlines', 'off', 'spheres', 'on', 'gui', 'off', 'normlen', 'on');
view([90 0]);
axes(handles.coronalAxes);
dipplot(sources.model, 'dipolesize', 40, 'projlines', 'off', 'spheres', 'on', 'gui', 'off', 'normlen', 'on');
view([0 0]);
rotate3d(gcf);
set(gcf, 'color', [0.66 0.76 1]);

% Plot envtopo
plotEnvelope(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function icIdxEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to icIdxEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function currentLatencyEdit_Callback(hObject, eventdata, handles)
% hObject    handle to currentLatencyEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentLatencyEdit as text
%        str2double(get(hObject,'String')) returns contents of currentLatencyEdit as a double

% import EEG
EEG = evalin('base', 'EEG');

% Set the data window to show
beginLatencySec = str2double(get(handles.currentLatencyEdit, 'String'));
windowSizeSec   = str2double(get(handles.windowSizeEdit, 'String'));
if      beginLatencySec + windowSizeSec > EEG.xmax
    beginLatencySec = EEG.xmax-windowSizeSec;
    set(handles.currentLatencyEdit, 'String', num2str(beginLatencySec));
    return
elseif beginLatencySec < EEG.xmin
    beginLatencySec = EEG.xmin;
    set(handles.currentLatencyEdit, 'String', num2str(beginLatencySec));
    return    
end

% Set current latency window
set(handles.currentLatencyEdit, 'String', num2str(beginLatencySec));

% Plot envtopo
plotEnvelope(hObject, eventdata, handles)

% Choose default command line output for pop_envtopoForContinuous
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function currentLatencyEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentLatencyEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function windowSizeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to windowSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of windowSizeEdit as text
%        str2double(get(hObject,'String')) returns contents of windowSizeEdit as a double

% import EEG
EEG = evalin('base', 'EEG');

% Set the data window to show
windowSizeSec = str2double(get(handles.windowSizeEdit, 'String'));
if windowSizeSec > EEG.xmax-EEG.xmin
    windowSizeSec = EEG.xmax-EEG.xmin;
    set(handles.windowSizeEdit, 'String', num2str(windowSizeSec));
    set(handles.currentLatencyEdit, 'String', '0');
    return
end

% Plot envtopo
plotEnvelope(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function windowSizeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in backwordPushbutton.
function backwordPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to backwordPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% import EEG
EEG = evalin('base', 'EEG');

% Set the data window to show
beginLatencySec = str2double(get(handles.currentLatencyEdit, 'String'));
if beginLatencySec < EEG.xmin
    beginLatencySec = EEG.xmin;
    set(handles.currentLatencyEdit, 'String', num2str(EEG.xmin))
    return
end

% Move backward the window
beginLatencySec = beginLatencySec - str2double(get(handles.windowSizeEdit, 'String'));
set(handles.currentLatencyEdit, 'String', num2str(beginLatencySec));

% Plot envtopo
plotEnvelope(hObject, eventdata, handles)

% Choose default command line output for pop_envtopoForContinuous
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in forwardPushbutton.
function forwardPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to forwardPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% import EEG
EEG = evalin('base', 'EEG');

% Set the data window to show
beginLatencySec = str2double(get(handles.currentLatencyEdit, 'String'));
windowSizeSec   = str2double(get(handles.windowSizeEdit, 'String'));
if beginLatencySec + windowSizeSec > EEG.xmax
    beginLatencySec = EEG.xmax-windowSizeSec;
    set(handles.currentLatencyEdit, 'String', num2str(beginLatencySec))
    return
end

% Move forward the window
beginLatencySec = beginLatencySec + str2double(get(handles.windowSizeEdit, 'String'));
set(handles.currentLatencyEdit, 'String', num2str(beginLatencySec));

% Plot envtopo
plotEnvelope(hObject, eventdata, handles)

% Choose default command line output for pop_envtopoForContinuous
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



function plotEnvelope(hObject, eventdata, handles)

% Set the data window to show
beginLatencySec = str2double(get(handles.currentLatencyEdit, 'String'));
endLatencySec   = beginLatencySec + str2double(get(handles.windowSizeEdit, 'String'));

% EEG.data
EEG = evalin('base', 'EEG');

% Obtain the current window
latencyIdx = find(EEG.times/1000 >= beginLatencySec & EEG.times/1000 <= endLatencySec);

% Outermost Envelope
outermostEnvUpper = max(EEG.data(:,latencyIdx));
outermostEnvLower = min(EEG.data(:,latencyIdx));

% Innter Envelope
selectedICs = str2double(get(handles.icIdxEdit, 'String'));
selectedEEG = pop_subcomp(EEG, setdiff(1:size(EEG.icaweights, 1), selectedICs), 0);
innerEnvUpper = max(selectedEEG.data(:,latencyIdx));
innerEnvLower = min(selectedEEG.data(:,latencyIdx));

% Plot
axes(handles.envelopeAxes)
cla(handles.envelopeAxes, 'reset')
latency = EEG.times/1000;
plot(latency(latencyIdx), outermostEnvUpper, 'Color', [0.66 0.76 1]); hold on
plot(latency(latencyIdx), outermostEnvLower, 'Color', [0.66 0.76 1]);
filledInEnvLatencySec = [latency(latencyIdx), fliplr(latency(latencyIdx))];
filledInEnv           = [innerEnvUpper fliplr(innerEnvLower)];
fill(filledInEnvLatencySec, filledInEnv, [1 0.66 0.76], 'edgeColor', [1 0.66 0.76]);
xlim([latency(latencyIdx(1)) latency(latencyIdx(end))])
set(get(handles.envelopeAxes, 'xlabel'), 'String', 'Latency (s)')
set(get(handles.envelopeAxes, 'ylabel'), 'String', 'RMS Microvolt')

% Broadband pvaf
allIcProjection      = EEG.data(        :,latencyIdx);
selectedIcProjection = selectedEEG.data(:,latencyIdx);
pvafBroadband        = 100-100*mean(var(allIcProjection-selectedIcProjection))/mean(var(allIcProjection));

% Delta pvaf
allIcProjectionFilt      = myEegfiltnew(allIcProjection,      EEG.srate, 1, 4);
selectedIcProjectionFilt = myEegfiltnew(selectedIcProjection, EEG.srate, 1, 4);
pvafDelta                = 100-100*mean(var(allIcProjectionFilt-selectedIcProjectionFilt))/mean(var(allIcProjectionFilt));

% Theta pvaf
allIcProjectionFilt      = myEegfiltnew(allIcProjection,      EEG.srate, 4, 8);
selectedIcProjectionFilt = myEegfiltnew(selectedIcProjection, EEG.srate, 4, 8);
pvafTheta                = 100-100*mean(var(allIcProjectionFilt-selectedIcProjectionFilt))/mean(var(allIcProjectionFilt));

% Alpha pvaf
allIcProjectionFilt      = myEegfiltnew(allIcProjection,      EEG.srate, 8, 13);
selectedIcProjectionFilt = myEegfiltnew(selectedIcProjection, EEG.srate, 8, 13);
pvafAlpha                = 100-100*mean(var(allIcProjectionFilt-selectedIcProjectionFilt))/mean(var(allIcProjectionFilt));

% Beta pvaf
allIcProjectionFilt      = myEegfiltnew(allIcProjection,      EEG.srate, 13, 30);
selectedIcProjectionFilt = myEegfiltnew(selectedIcProjection, EEG.srate, 13, 30);
pvafBeta                 = 100-100*mean(var(allIcProjectionFilt-selectedIcProjectionFilt))/mean(var(allIcProjectionFilt));

% Gamma pvaf
allIcProjectionFilt      = myEegfiltnew(allIcProjection,      EEG.srate, 30, []);
selectedIcProjectionFilt = myEegfiltnew(selectedIcProjection, EEG.srate, 30, []);
pvafGamma                = 100-100*mean(var(allIcProjectionFilt-selectedIcProjectionFilt))/mean(var(allIcProjectionFilt));

% display the result
str = sprintf('Percent Variance Accounted For(PVAF):\nBroadband, %.1f\n\nDelta(1-4Hz), %.1f\nTheta(4-8Hz), %.1f\nAlpha(8-3Hz), %.1f\nBeta(13-30Hz), %.1f\nGamma(30Hz-), %.1f', pvafBroadband, pvafDelta, pvafTheta, pvafAlpha, pvafBeta, pvafGamma);
set(handles.pvafText, 'String', str);

% Choose default command line output for pop_envtopoForContinuous
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



function filteredData = myEegfiltnew(data, srate, locutoff, hicutoff)
disp('Applying low pass filter (Hamming).')
disp('Transition band width is the half of the passband edge frequency.')
tmpFiltData.data   = data;
tmpFiltData.srate  = srate;
tmpFiltData.trials = 1;
tmpFiltData.event  = [];
tmpFiltData.pnts   = length(data);
tmpFiltData_done   = pop_eegfiltnew(tmpFiltData, locutoff, hicutoff);
filteredData       = tmpFiltData_done.data;
