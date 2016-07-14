function varargout = brainBlobBrowser(varargin)
% BRAINBLOBBROWSER MATLAB code for brainBlobBrowser.fig
%
%      Example:
%      brainBlobBrowser('data', rand(91,109,91), 'color', 'red')
%
%      Input:
%      'data'  - input data. Size must be [91 109 91]
%      'color' - color scheme in plot. ['red'|'blue'|'green'|'magenta'|'blue-green'|'purple-green']
%      'mri'   - mri data
%
%      BRAINBLOBBROWSER, by itself, creates a new BRAINBLOBBROWSER or raises the existing
%      singleton*.
%
%      H = BRAINBLOBBROWSER returns the handle to a new BRAINBLOBBROWSER or the handle to
%      the existing singleton*.
%
%      BRAINBLOBBROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BRAINBLOBBROWSER.M with the given input arguments.
%
%      BRAINBLOBBROWSER('Property','Value',...) creates a new BRAINBLOBBROWSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before brainBlobBrowser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to brainBlobBrowser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help brainBlobBrowser

% Last Modified by GUIDE v2.5 03-Sep-2014 09:01:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @brainBlobBrowser_OpeningFcn, ...
                   'gui_OutputFcn',  @brainBlobBrowser_OutputFcn, ...
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


% --- Executes just before brainBlobBrowser is made visible.
function brainBlobBrowser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to brainBlobBrowser (see VARARGIN)

% Background color
set(hObject, 'Color', [0 0 0]) 

% this uses Christian's function
userInput = hlp_varargin2struct(varargin);

% add spm8 to the path
% addpath /data/projects/makoto/Tools/spm8

% check input
if ~isfield(userInput, 'data')
    error('No input data provided.')
%     disp(sprintf('\n\nNo input data.'));
%     disp('SupraMarginal_L will be shown for demo. ')
%     disp('The input data must be 91x109x91 of 2x2x2 voxels, ranges -88:92, -128:90, -74:108')
%     % load AAL-segmented brain from nii (ComeOnJohnAshburner)
%     tmpAAL = spm_vol('/data/projects/makoto/Tools/spm8/toolbox/wfu_pickatlas/MNI_atlas_templates/aal_MNI_V4.nii');
%     Vols = zeros(numel(tmpAAL),1);
%     for j=1:numel(tmpAAL),
%         tot = 0;
%         for i=1:tmpAAL(1).dim(3),
%                 img     = spm_slice_vol(tmpAAL(j),spm_matrix([0 0 i]),tmpAAL(j).dim(1:2),0);
%                 pileimg(:,:,i) = img; 
%         end;
%     end
%     handles.cubeAAL = pileimg;
%     handles.roiAAL = handles.cubeAAL==63; % SupraMarginal_L
%     handles.inputData = smooth3(handles.roiAAL, 'gaussian', [7 7 7]);
else
    if isequal(size(userInput.data),[91 109 91])
        handles.inputData = userInput.data;
    else
        error('Invalid input data.')
    end
end

if ~isfield(userInput, 'mri')
    dipfitdefs;
    load('-mat', template_models(1).mrifile); % load mri variable
else
    if isequal(size(userInput.mri),[91 109 91])
        mri = userInput.mri;
    else
        error('Invalid input data.')
    end
end

% read MNI template header
% hdr = spm_read_hdr('/data/projects/makoto/Tools/spm8/canonical/single_subj_T1.nii');
handles.dimension = [91 109 91];
% handles.voxelSize = hdr.dime.pixdim(2:4);
% handles.origin    = [0 0 0];% if any(handles.origin); error('Origin is not [0 0 0].'); end
% http://imaging.mrc-cbu.cam.ac.uk/imaging/FormatAnalyze
% Note that if the Origin is set to 0 0 0, then SPM routines will assume that the origin is in fact the central voxel of the image.
% handles.dimensionInMillimeter = [-(handles.dimension.*handles.voxelSize)/2; (handles.dimension.*handles.voxelSize)/2];
handles.currentPointer = [46 64 37];

% Note that origine in voxel space is [46 64 37]
% set up scroll bars: right top == sagittal == slider4
set(handles.slider4,'Value', 46)
set(handles.slider4,'Min', 1)
set(handles.slider4,'Max', handles.dimension(1))

% set up scroll bars: left top == colonal == slider2
set(handles.slider2,'Value', 64)
set(handles.slider2,'Min', 1)
set(handles.slider2,'Max', handles.dimension(2))

% set up scroll bars: left bottom == axial == slider5
set(handles.slider5,'Value', 37)
set(handles.slider5,'Min', 1)
set(handles.slider5,'Max', handles.dimension(3))

% load SPM single-subject T1 from nii (ComeOnJohnAshburner)
% tmpT1 = spm_vol('/data/projects/makoto/Tools/spm8/canonical/single_subj_T1.nii');
% V.mat   - a 4x4 affine transformation matrix mapping from
%           voxel coordinates to real world coordinates.
handles.affinMat = mri.transform; % don't forget to add the last '1' after the voxel coordinate!
% handles.affinMat = tmpT1.mat; % don't forget to add the last '1' after the voxel coordinate!
handles.affinMat(1,1) = handles.affinMat(1,1)*-1; % non-radiological convention
handles.affinMat(1,4) = handles.affinMat(1,4)*-1; % non-radiological convention
Vols = zeros(numel(mri),1);
for j=1:numel(mri),
    tot = 0;
    for i=1:mri(1).dim(3),
%         img     = spm_slice_vol(tmpT1(j),spm_matrix([0 0 i]),tmpT1(j).dim(1:2),0);
        img = mri.anatomy(:,:,i);
        pileimg(:,:,i) = img;
    end;
end
handles.cubeT1 = pileimg;

% define color map
if ~isfield(userInput,'color')
    handles.cmap = colormap(jet(195-74));
    handles.cmap(1,:) = 0;
    disp(sprintf('\n\nNo color specified.'));
    disp('Color scheme is jet.')
else
    handles.cmap = colormap(hot(200));
    handles.cmap = handles.cmap(75:195,:);
    if     strcmp(userInput.color, 'red')
        disp('Color scheme is red.')
    elseif strcmp(userInput.color, 'blue')
        handles.cmap = handles.cmap(:, [3 2 1]); 
        disp('Color scheme is blue.')
    elseif strcmp(userInput.color, 'green')
        handles.cmap = handles.cmap(:, [2 1 3]);
        disp('Color scheme is blue.')
    elseif strcmp(userInput.color, 'magenta')
        handles.cmap = handles.cmap(:, [1 3 2]);
        disp('Color shceme is magenta')
    elseif strcmp(userInput.color, 'blue-green')
        handles.cmap = handles.cmap(:, [3 1 2]);
        disp('Color shceme is blue-green')
    elseif strcmp(userInput.color, 'purple-blue')
        handles.cmap = handles.cmap(:, [2 3 1]);
        disp('Color shceme is purple-blue')
    else
        error('Unsupported color.')
    end
end

% Choose default command line output for brainBlobBrowser
handles.output = hObject;

% update data
handles = prepare_dens(handles);
handles.alpha = .4;

% update handles
guidata(hObject, handles);

% draw maps
drawAxial(   hObject, eventdata, handles)
drawSagittal(hObject, eventdata, handles)
drawColonal( hObject, eventdata, handles)

% draw colorbar
% colorbarHandle = colorbar(handles.axes2, 'EastOutside');
% set(colorbarHandle, 'Ticks', [])
% warning('off','MATLAB:colorbar:DeprecatedV6Argument');

% colormap(handles.cmap); % probably...
% set(handles.axes4, 'YTick', [1 200], 'YTickLabel', {'0' handles.maxdens})
% set(handles.axes4, 'YTick', [1 200], 'YTickLabel', {'1' num2str(userInput.normCoeff)})

% UIWAIT makes brainBlobBrowser wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = brainBlobBrowser_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function [handles maxdens] = prepare_dens(handles)

handles.maxdens = max(handles.inputData(:));
% ncolors = size(handles.cmap,1);
% handles.inputData(~handles.inputData) = nan;
% 
% handles.inputData    = round((handles.inputData)/(handles.maxdens)*(ncolors-1))+1; % project desnity image into the color space: [1:ncolors]
% handles.inputData( find(handles.inputData > ncolors) ) = ncolors;
% handles.inputData( find(handles.inputData < 1))        = 1; % added by Makoto
% % newprob3d = zeros(size(handles.inputData,1), size(handles.inputData,2), size(handles.inputData,3), 3);
% 
% % outOfBrainMask = find(isnan(handles.inputData)); % place NaNs in a mask, NaNs are assumed for points outside the brain
% % handles.inputData(outOfBrainMask) = 1;
handles.inputData = handles.inputData./max(handles.inputData(:));
% handles.inputData(isnan(handles.inputData)) = 0;


% tmp = handles.cmap(handles.inputData,1); newprob3d(:,:,:,1) = reshape(tmp, size(handles.inputData));
% tmp = handles.cmap(handles.inputData,2); newprob3d(:,:,:,2) = reshape(tmp, size(handles.inputData));
% tmp = handles.cmap(handles.inputData,3); newprob3d(:,:,:,3) = reshape(tmp, size(handles.inputData));


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.currentPointer(2) = round(get(hObject,'Value'));
% update handles
guidata(hObject, handles);
drawColonal( hObject, eventdata, handles)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.currentPointer(1) = round(get(hObject,'Value'));
% update handles
guidata(hObject, handles);
drawSagittal( hObject, eventdata, handles)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.currentPointer(3) = round(get(hObject,'Value'));
% update handles
guidata(hObject, handles);
drawAxial( hObject, eventdata, handles)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function drawAxial(hObject, eventdata, handles)
currentZ = handles.currentPointer(3);
% background brain image
tmpT1Slice      = rot90(handles.cubeT1(:,:,currentZ)); % rotate to frontal-up
tmpT1SliceColor = repmat(tmpT1Slice, [1 1 3]);
axes(handles.axes3);
% image(tmpT1SliceColor);
set(gca,'XTickLabel', '', 'YTickLabel', '')
tmpCData = get(get(handles.axes3,'Children'), 'CData');
% 'overlay' activation blob 
inputDataSlice = squeeze(rot90(handles.inputData(:,:,currentZ)));
inputDataSlice_colorIdx = round(inputDataSlice*(195-75));
inputDataSlice_colorIdx(inputDataSlice_colorIdx==0)=1;
inputDataSliceR = reshape(handles.cmap(inputDataSlice_colorIdx,1), size(inputDataSlice_colorIdx));
inputDataSliceG = reshape(handles.cmap(inputDataSlice_colorIdx,2), size(inputDataSlice_colorIdx));
inputDataSliceB = reshape(handles.cmap(inputDataSlice_colorIdx,3), size(inputDataSlice_colorIdx));
inputDataSliceColor = cat(3, inputDataSliceR, inputDataSliceG, inputDataSliceB);
image(handles.alpha*inputDataSliceColor + (1 - handles.alpha)*tmpT1SliceColor);
set(gca,'XTickLabel', '', 'YTickLabel', '')
currentPointerInRealWorld = handles.affinMat*[handles.currentPointer';1];
set(handles.text9, 'String', num2str(currentPointerInRealWorld(3)), 'FontSize', 16);

function drawSagittal(hObject, eventdata, handles)
currentX = handles.currentPointer(1);
% background brain image
tmpT1Slice      = rot90(squeeze(handles.cubeT1(currentX,:,:))); % rotate to frontal-up
tmpT1SliceColor = repmat(tmpT1Slice, [1 1 3]);
axes(handles.axes2);
image(tmpT1SliceColor);

set(gca,'XTickLabel', '', 'YTickLabel', '')
tmpCData = get(get(handles.axes2,'Children'), 'CData');
% 'overlay' activation blob 
inputDataSlice = rot90(squeeze(handles.inputData(currentX,:,:)));
inputDataSlice_colorIdx = round(inputDataSlice*(195-75));
inputDataSlice_colorIdx(inputDataSlice_colorIdx==0)=1;
inputDataSliceR = reshape(handles.cmap(inputDataSlice_colorIdx,1), size(inputDataSlice_colorIdx));
inputDataSliceG = reshape(handles.cmap(inputDataSlice_colorIdx,2), size(inputDataSlice_colorIdx));
inputDataSliceB = reshape(handles.cmap(inputDataSlice_colorIdx,3), size(inputDataSlice_colorIdx));
inputDataSliceColor = cat(3, inputDataSliceR, inputDataSliceG, inputDataSliceB);
inputDataSliceColor = cat(3, inputDataSliceR, inputDataSliceG, inputDataSliceB);
image(handles.alpha*inputDataSliceColor + (1 - handles.alpha)*tmpT1SliceColor);
set(gca,'XTickLabel', '', 'YTickLabel', '')
currentPointerInRealWorld = handles.affinMat*[handles.currentPointer';1];
set(handles.text5, 'String', num2str(currentPointerInRealWorld(1)), 'FontSize', 16);
% colorbarHandle = colorbar(handles.axes2, 'EastOutside');
if ~isfield(handles, 'colorbarHandle')
    handles.colorbarHandle = colorbar;
    set(handles.colorbarHandle, 'YTick', [], 'Position', [0.9098 0.1115 0.0689 0.2797]);
    set(handles.axes2, 'Position', [1.4286 7.2857 52.4048 17.9286]);
    % warning('off','MATLAB:colorbar:DeprecatedV6Argument');
end


function drawColonal(hObject, eventdata, handles)
currentY = handles.currentPointer(2);
% background brain image
tmpT1Slice      = rot90(squeeze(handles.cubeT1(:,currentY,:))); % rotate to frontal-up
tmpT1SliceColor = repmat(tmpT1Slice, [1 1 3]);
axes(handles.axes1);
image(tmpT1SliceColor);
set(gca,'XTickLabel', '', 'YTickLabel', '')
tmpCData = get(get(handles.axes1,'Children'), 'CData');
% 'overlay' activation blob 
inputDataSlice = rot90(squeeze(handles.inputData(:,currentY,:)));
inputDataSlice_colorIdx = round(inputDataSlice*(195-75));
inputDataSlice_colorIdx(inputDataSlice_colorIdx==0)=1;
inputDataSliceR = reshape(handles.cmap(inputDataSlice_colorIdx,1), size(inputDataSlice_colorIdx));
inputDataSliceG = reshape(handles.cmap(inputDataSlice_colorIdx,2), size(inputDataSlice_colorIdx));
inputDataSliceB = reshape(handles.cmap(inputDataSlice_colorIdx,3), size(inputDataSlice_colorIdx));
inputDataSliceColor = cat(3, inputDataSliceR, inputDataSliceG, inputDataSliceB);
inputDataSliceColor = cat(3, inputDataSliceR, inputDataSliceG, inputDataSliceB);
image(handles.alpha*inputDataSliceColor + (1 - handles.alpha)*tmpT1SliceColor);
set(gca,'XTickLabel', '', 'YTickLabel', '')
currentPointerInRealWorld = handles.affinMat*[handles.currentPointer';1];
set(handles.text8, 'String', num2str(currentPointerInRealWorld(2)), 'FontSize', 16);
