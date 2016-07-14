function varargout = std_plot_selectICsByCluster(varargin)
% STD_PLOT_SELECTICSBYCLUSTER MATLAB code for std_plot_selectICsByCluster.fig
%      STD_PLOT_SELECTICSBYCLUSTER, by itself, creates a new STD_PLOT_SELECTICSBYCLUSTER or raises the existing
%      singleton*.
%
%      H = STD_PLOT_SELECTICSBYCLUSTER returns the handle to a new STD_PLOT_SELECTICSBYCLUSTER or the handle to
%      the existing singleton*.
%
%      STD_PLOT_SELECTICSBYCLUSTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STD_PLOT_SELECTICSBYCLUSTER.M with the given input arguments.
%
%      STD_PLOT_SELECTICSBYCLUSTER('Property','Value',...) creates a new STD_PLOT_SELECTICSBYCLUSTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before std_plot_selectICsByCluster_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to std_plot_selectICsByCluster_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help std_plot_selectICsByCluster

% Last Modified by GUIDE v2.5 22-May-2015 13:37:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @std_plot_selectICsByCluster_OpeningFcn, ...
                   'gui_OutputFcn',  @std_plot_selectICsByCluster_OutputFcn, ...
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


% --- Executes just before std_plot_selectICsByCluster is made visible.
function std_plot_selectICsByCluster_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to std_plot_selectICsByCluster (see VARARGIN)

% Choose default command line output for std_plot_selectICsByCluster
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes std_plot_selectICsByCluster wait for user response (see UIRESUME)
% uiwait(handles.figure1);
handles.channelToPlot;

% --- Outputs from this function are returned to the command line.
function varargout = std_plot_selectICsByCluster_OutputFcn(hObject, eventdata, handles)  %#ok<*STOUT>
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
set(handles.pvafDisplay,   'Enable', 'off');


% --- Executes on selection change in ERP_or_Envelope.
function ERP_or_Envelope_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to ERP_or_Envelope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
currentSelection = contents{get(hObject,'Value')};
if strcmp(currentSelection, 'ERP')
    set(handles.channelToPlot, 'Enable', 'on');
    set(handles.pvafDisplay,   'Enable', 'off');
    set(handles.baselineRange, 'Enable', 'on');
    set(handles.baselineRangeText, 'Enable', 'on');
else
    set(handles.channelToPlot, 'Enable', 'off');
    set(handles.baselineRange, 'Enable', 'off');
    set(handles.baselineRangeText, 'Enable', 'off');
end
plotButton_Callback(hObject, eventdata, handles)

% Hints: contents = cellstr(get(hObject,'String')) returns ERP_or_Envelope contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ERP_or_Envelope


% --- Executes during object creation, after setting all properties.
function ERP_or_Envelope_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to ERP_or_Envelope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotRange_Callback(hObject, eventdata, handles)
% hObject    handle to plotRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotRange as text
%        str2double(get(hObject,'String')) returns contents of plotRange as a double
STUDY = evalin('base','STUDY');
latencyRangeValues = str2num(get(hObject,'String'));
minLatency = latencyRangeValues(1);
maxLatency = latencyRangeValues(2);
[~,minLatencyIdx] = min(abs(STUDY.selectICsByCluster.latencyInMillisecond-minLatency));
[~,maxLatencyIdx] = min(abs(STUDY.selectICsByCluster.latencyInMillisecond-maxLatency));
newString = num2str([STUDY.selectICsByCluster.latencyInMillisecond(minLatencyIdx) STUDY.selectICsByCluster.latencyInMillisecond(maxLatencyIdx)]);
set(hObject, 'String', newString);
plotButton_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function plotRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
STUDY = evalin('base', 'STUDY');
defaultMinLatency = num2str(STUDY.selectICsByCluster.latencyInMillisecond(1));
defaultMaxLatency = num2str(STUDY.selectICsByCluster.latencyInMillisecond(end));
set(hObject, 'String', [defaultMinLatency ' ' defaultMaxLatency]);

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in withinSubjectCondition.
function withinSubjectCondition_Callback(hObject, eventdata, handles)
% hObject    handle to withinSubjectCondition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns withinSubjectCondition contents as cell array
%        contents{get(hObject,'Value')} returns selected item from withinSubjectCondition
plotButton_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function withinSubjectCondition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to withinSubjectCondition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
STUDY = evalin('base', 'STUDY');
if isfield(STUDY.selectICsByCluster, 'withinSubjectCondition')
%         %here is the check code
%         %mergedWithinSubjectCondition   = STUDY.selectICsByCluster.withinSubjectCondition;
%         %separateWithinSubjectCondition = mergedWithinSubjectCondition{1,1}; 
%         STUDY.selectICsByCluster.withinSubjectCondition = mergedWithinSubjectCondition;
%         STUDY.selectICsByCluster.withinSubjectCondition = separateWithinSubjectCondition;
    conditionList = STUDY.selectICsByCluster.withinSubjectCondition;
    for n = 1:length(conditionList)
        if iscell(conditionList{1,n}) % conditions merged?
            % tmpCondition = strjoin(conditionList{1,n}, '&'); % DO NOT USE strjoin since this is heavily overloaded and tend to use the wrong one!
            tmpCell = conditionList{1,n};
            tmpCell(2,:) = {' & '};
            tmpCell{2,end} = '';
            tmpCondition = [tmpCell{:}];
        else
            tmpCondition = conditionList{1,n};
        end
        finalList{1,n} = tmpCondition; %#ok<*AGROW>
    end
    set(hObject, 'String', finalList);
    set(hObject, 'Enable', 'on');
else
    set(hObject, 'String', 'Single condition');
    set(hObject, 'Enable', 'off');
end

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in betweenSubjectCondition.
function betweenSubjectCondition_Callback(hObject, eventdata, handles)
% hObject    handle to betweenSubjectCondition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns betweenSubjectCondition contents as cell array
%        contents{get(hObject,'Value')} returns selected item from betweenSubjectCondition
plotButton_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function betweenSubjectCondition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to betweenSubjectCondition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
STUDY = evalin('base', 'STUDY');
if isfield(STUDY.selectICsByCluster, 'betweenSubjectCondition')
%         %here is the check code
%         %mergedGroupLevels   = STUDY.selectICsByCluster.betweenSubjectCondition;
%         %separateGroupLevels = mergedGroupLevels{1,1}; 
%         STUDY.selectICsByCluster.betweenSubjectCondition = mergedGroupLevels;
%         STUDY.selectICsByCluster.betweenSubjectCondition = separateGroupLevels;
    conditionList = STUDY.selectICsByCluster.betweenSubjectCondition;
    for n = 1:length(conditionList)
        if iscell(conditionList{1,n}) % conditions merged?
            % tmpCondition = strjoin(conditionList{1,n}, '&'); % AVOID strjoin!
            tmpCell = conditionList{1,n};
            tmpCell(2,:) = {' & '};
            tmpCell{2,end} = '';
            tmpCondition = [tmpCell{:}];
        else
            tmpCondition = conditionList{1,n};
        end
        finalList{1,n} = tmpCondition;
    end
    set(hObject, 'String', finalList);
else
    set(hObject, 'String', 'Single group');
    set(hObject, 'Enable', 'off');
end

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in channelToPlot.
function channelToPlot_Callback(hObject, eventdata, handles)
% hObject    handle to channelToPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns channelToPlot contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channelToPlot
plotButton_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function channelToPlot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelToPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
channelList = evalin('base', 'STUDY.selectICsByCluster.channelList');
set(hObject, 'String', channelList);

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function baselineRange_Callback(hObject, eventdata, handles)
% hObject    handle to baselineRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of baselineRange as text
%        str2double(get(hObject,'String')) returns contents of baselineRange as a double
STUDY = evalin('base','STUDY');
latencyRangeValues = str2num(get(hObject,'String'));
minLatency = latencyRangeValues(1);
maxLatency = latencyRangeValues(2);
[~,minLatencyIdx] = min(abs(STUDY.selectICsByCluster.latencyInMillisecond-minLatency));
[~,maxLatencyIdx] = min(abs(STUDY.selectICsByCluster.latencyInMillisecond-maxLatency));
newString = num2str([STUDY.selectICsByCluster.latencyInMillisecond(minLatencyIdx) STUDY.selectICsByCluster.latencyInMillisecond(maxLatencyIdx)]);
set(hObject, 'String', newString);
plotButton_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function baselineRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to baselineRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

STUDY = evalin('base','STUDY');
latency = STUDY.selectICsByCluster.latencyInMillisecond;
negativeLatencyIdx = find(latency<=0);
if any(negativeLatencyIdx)
    baselineRange = [latency(negativeLatencyIdx(1)) latency(negativeLatencyIdx(end))];
else
    baselineRange = [latency(1) latency(end)];
end
set(hObject, 'String', num2str(baselineRange));

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function lowPassFilter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ERP_or_Envelope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function lowPassFilter_Callback(hObject, eventdata, handles)
% hObject    handle to text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text as text
%        str2double(get(hObject,'String')) returns contents of text as a double
plotButton_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject, 'String', '');

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in export.
function export_Callback(hObject, eventdata, handles)
% hObject    handle to export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% launch GUI to obtain directory
switch get(handles.ERP_or_Envelope, 'Value')
    case 1
        [FileName,PathName] = uiputfile('_erp.txt');
    case 2
        [FileName,PathName] = uiputfile('_env.txt');
end
set(hObject,'UserData',[PathName FileName]);
plotButton_Callback(hObject, eventdata, handles)
disp(['Exported to ' PathName FileName])







% --- Executes on button press in plotButton.
function plotButton_Callback(hObject, eventdata, handles)
% hObject    handle to plotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
STUDY = evalin('base', 'STUDY');
contents = cellstr(get(handles.ERP_or_Envelope,'String'));
currentSelection = contents{get(handles.ERP_or_Envelope,'Value')};

tmpWithinSubjectCondition  = get(handles.withinSubjectCondition, 'Value');
tmpBetweenSubjectCondition = get(handles.betweenSubjectCondition, 'Value');
tmpPlotRange               = str2num(get(handles.plotRange, 'String')); %#ok<*ST2NM>

% convert millisecond to the closest latency frame
[~,minFrameIdx] = min(abs(STUDY.selectICsByCluster.latencyInMillisecond-tmpPlotRange(1,1)));
[~,maxFrameIdx] = min(abs(STUDY.selectICsByCluster.latencyInMillisecond-tmpPlotRange(1,2)));
baselineRange = str2num(get(handles.baselineRange,'String'));
minBaseIdx = find(STUDY.selectICsByCluster.latencyInMillisecond==baselineRange(1,1));
maxBaseIdx = find(STUDY.selectICsByCluster.latencyInMillisecond==baselineRange(1,2));

if strcmp(currentSelection, 'ERP')
    tmpChannelIdx = get(handles.channelToPlot, 'Value');
    
    % betweenSubjectCondition present
    if isfield(STUDY.selectICsByCluster, 'betweenSubjectCondition')
        if length(STUDY.selectICsByCluster.betweenSubjectCondition)>1
            groupSubsetList = find(STUDY.selectICsByCluster.groupList==tmpBetweenSubjectCondition);
            allSubjERP = squeeze(STUDY.selectICsByCluster.selectICsByClusterErp(tmpChannelIdx,:,groupSubsetList,tmpWithinSubjectCondition));
        else
            allSubjERP = squeeze(STUDY.selectICsByCluster.selectICsByClusterErp(tmpChannelIdx,:,:,tmpWithinSubjectCondition));
        end
    else
        allSubjERP = squeeze(STUDY.selectICsByCluster.selectICsByClusterErp(tmpChannelIdx,:,:,tmpWithinSubjectCondition));
    end
    
    % low-pass filter HERE
    if any(get(handles.lowPassFilter, 'String'))
        passbandEdge = str2num(get(handles.lowPassFilter, 'String'));
        srate = evalin('base', 'ALLEEG(1,1).srate');
        allSubjERP = myeegfilt(allSubjERP', srate, 0, passbandEdge)';
    end

    % baseline correction
    allSubjERP  = allSubjERP-repmat(mean(allSubjERP(minBaseIdx:maxBaseIdx,:)), [size(allSubjERP,1),1]);
    fullLatency = STUDY.selectICsByCluster.latencyInMillisecond;
    
    % compute mean and STD
    grandaveERP = mean(allSubjERP,2);
    stdGrandave = std(allSubjERP,0,2);
    
    % limit latency
    grandaveERP = grandaveERP(minFrameIdx:maxFrameIdx);
    stdGrandave = stdGrandave(minFrameIdx:maxFrameIdx);
    
    % plot ERP plus SD envelope
    mainPlot = plot(handles.mainPlotWindow, STUDY.selectICsByCluster.latencyInMillisecond(minFrameIdx:maxFrameIdx), grandaveERP, 'LineWidth',2, 'Color', [0.4 0.4 1]);
    hold on
    env1 = grandaveERP+stdGrandave;
    env2 = grandaveERP-stdGrandave;
    plotLatency = STUDY.selectICsByCluster.latencyInMillisecond(minFrameIdx:maxFrameIdx);
    X = [plotLatency,fliplr(plotLatency)];
    Y = [env1',fliplr(env2')];             
    fill(X,Y,[0.93 0.96 1], 'Edgecolor', [0.7 0.7 0.7]);
    uistack(mainPlot, 'top')
    
    % export HERE
    if any(get(handles.export, 'UserData'))
        exportData = double([fullLatency' allSubjERP]);
        save(get(handles.export, 'UserData'), 'exportData', '-ascii');
        STUDY.selectICsByCluster.lastExportData = single(exportData);
        set(handles.export, 'UserData', '');
    end
    
    % limit plot
    xlim([tmpPlotRange(1,1) tmpPlotRange(1,2)])
    ymin = min(env2)*1.05;
    ymax = max(env1)*1.05;
    ylim([ymin ymax])
    
    % vertical and horizontal lines http://stackoverflow.com/questions/8086943/how-to-add-a-x-axis-line-to-a-figure-matlab
    % This is depricated in Matlab 2014b...
    %     hx = graph2d.constantline(0, 'LineStyle','--', 'Color',[.6 .6 .6]);
    %     changedependvar(hx,'x');
    %     hy = graph2d.constantline(0, 'Color',[.6 .6 .6]);
    %     changedependvar(hy,'y');
    plot(xlim, [0 0], 'Color',[.6 .6 .6])
    plot([0 0], ylim, 'LineStyle','--', 'Color',[.6 .6 .6])

    xlabel('Latency (ms)');
    ylabel('Amplitude (uV)');
    set(handles.mainPlotWindow, 'box', 'off');
    set(findall(gca,'-property','FontSize'),'FontSize',13)
    
    set(handles.pvafDisplay,'Enable', 'off', 'String', 'PVAF:')
else
    % betweenSubjectCondition present
    if isfield(STUDY.selectICsByCluster, 'betweenSubjectCondition')
        if length(STUDY.selectICsByCluster.betweenSubjectCondition)>1
            groupSubsetList = find(STUDY.selectICsByCluster.groupList==tmpBetweenSubjectCondition);
            tmpOutEnv      = mean(STUDY.selectICsByCluster.outermostEnv(:,:,groupSubsetList,tmpWithinSubjectCondition),3);
            tmpBackprojEnv = mean(STUDY.selectICsByCluster.selectICsByClusterEnv(:,:,groupSubsetList,tmpWithinSubjectCondition),3);
            tmpPVAF        = mean(STUDY.selectICsByCluster.erpPvaf(minFrameIdx:maxFrameIdx,groupSubsetList,tmpWithinSubjectCondition),2);
        else
            tmpOutEnv      = mean(STUDY.selectICsByCluster.outermostEnv(:,:,:,tmpWithinSubjectCondition),3);
            tmpBackprojEnv = mean(STUDY.selectICsByCluster.selectICsByClusterEnv(:,:,:,tmpWithinSubjectCondition),3);
            tmpPVAF        = mean(STUDY.selectICsByCluster.erpPvaf(:,tmpWithinSubjectCondition));
        end
    else
        tmpOutEnv      = mean(STUDY.selectICsByCluster.outermostEnv(:,:,:,tmpWithinSubjectCondition),3);
        tmpBackprojEnv = mean(STUDY.selectICsByCluster.selectICsByClusterEnv(:,:,:,tmpWithinSubjectCondition),3);
        tmpPVAF        = mean(STUDY.selectICsByCluster.erpPvaf(:,tmpWithinSubjectCondition));
    end

    % low-pass filter HERE
    if any(get(handles.lowPassFilter, 'String'))
        passbandEdge = str2num(get(handles.lowPassFilter, 'String'));
        srate = evalin('base', 'ALLEEG(1,1).srate');
        tmpOutEnv      = myeegfilt(tmpOutEnv,      srate, 0, passbandEdge);
        tmpBackprojEnv = myeegfilt(tmpBackprojEnv, srate, 0, passbandEdge);
    end

    % limit latency
    tmpOutEnv      = tmpOutEnv(:,minFrameIdx:maxFrameIdx);
    tmpBackprojEnv = tmpBackprojEnv(:,minFrameIdx:maxFrameIdx);

    % plot outermost envelope
    plotLatency = STUDY.selectICsByCluster.latencyInMillisecond(minFrameIdx:maxFrameIdx);
    X = [plotLatency,fliplr(plotLatency)];
    Y = [tmpOutEnv(1,:),fliplr(tmpOutEnv(2,:))];
    fill(X,Y,[0.93 0.93 0.97], 'EdgeColor', [0.7 0.7 0.7]);
    hold on

    % plot selectICsByClusterected envelope
    Z = [tmpBackprojEnv(1,:),fliplr(tmpBackprojEnv(2,:))];
    fill(X,Z,[1 0.7 0.7], 'EdgeColor', [0.7 0.7 0.7]);
    
    % export HERE
    if any(get(handles.export, 'UserData'))
        exportData = double([plotLatency' tmpOutEnv' tmpBackprojEnv' tmpPVAF]);
        save(get(handles.export, 'UserData'), 'exportData', '-ascii');
        STUDY.selectICsByCluster.lastExportData = single(exportData);
        set(handles.export, 'UserData', '');
    end
    
    % vertical and horizontal lines http://stackoverflow.com/questions/8086943/how-to-add-a-x-axis-line-to-a-figure-matlab
    % This method is depricated in Matlab 2014b
    %     hx = graph2d.constantline(0, 'LineStyle','--', 'Color',[.6 .6 .6]);
    %     changedependvar(hx,'x');
    %     hy = graph2d.constantline(0, 'Color',[.6 .6 .6]);
    %     changedependvar(hy,'y');
    plot(xlim, [0 0], 'Color',[.6 .6 .6])
    plot([0 0], ylim, 'LineStyle','--', 'Color',[.6 .6 .6])
    
    ymin = min(tmpOutEnv(2,:))*1.05;
    ymax = max(tmpOutEnv(1,:))*1.05;
    xlim([tmpPlotRange(1,1) tmpPlotRange(1,2)])
    ylim([ymin ymax])
    
    xlabel('Latency (ms)');
    ylabel('Amplitude (Root-Mean-Square uV)');
    set(handles.mainPlotWindow, 'box', 'off');
    set(findall(gca,'-property','FontSize'),'FontSize',13)
    
    % display PVAF
    finalPVAF = sprintf('%2.1f', round(mean(tmpPVAF)*10)/10);
    set(handles.pvafDisplay,'Enable', 'on', 'String', ['PVAF: ' finalPVAF])
end
hold off

% display how many subjects and ICs are being used
allSubj = length(STUDY.subject);
if isfield(STUDY.selectICsByCluster, 'betweenSubjectCondition')
    if length(STUDY.selectICsByCluster.betweenSubjectCondition)>1
        numSubj = length(groupSubsetList);
        numICs  = length(find(ismember(STUDY.selectICsByCluster.includeIcList(:,1),groupSubsetList)));
    else
        numSubj = length(STUDY.selectICsByCluster.subjectList);
        numICs  = size(STUDY.selectICsByCluster.includeIcList,1);
    end
else
    numSubj = length(STUDY.selectICsByCluster.subjectList);
    numICs  = size(STUDY.selectICsByCluster.includeIcList,1);
end
set(handles.howManySubj, 'String', sprintf('%.0f/%.0f Subj, %.0f ICs', numSubj, allSubj, numICs))


% use eegfiltnew()
function smoothdata = myeegfilt(data, srate, locutoff, hicutoff)
disp('Applying low pass filter (Hamming).')
disp('Transition band width is the half of the passband edge frequency.')
tmpFiltData.data   = data;
tmpFiltData.srate  = srate;
tmpFiltData.trials = 1;
tmpFiltData.event  = [];
tmpFiltData.pnts   = length(data);
filtorder = pop_firwsord('hamming', srate, hicutoff/2);
tmpFiltData_done   = pop_eegfiltnew(tmpFiltData, locutoff, hicutoff, filtorder);
smoothdata         = tmpFiltData_done.data;
