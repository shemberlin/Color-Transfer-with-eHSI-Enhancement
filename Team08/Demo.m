function varargout = Demo(varargin)
% DEMO MATLAB code for Demo.fig
%      DEMO, by itself, creates a new DEMO or raises the existing
%      singleton*.
%
%      H = DEMO returns the handle to a new DEMO or the handle to
%      the existing singleton*.
%
%      DEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEMO.M with the given input arguments.
%
%      DEMO('Property','Value',...) creates a new DEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Demo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Demo

% Last Modified by GUIDE v2.5 27-Dec-2017 21:42:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Demo_OpeningFcn, ...
                   'gui_OutputFcn',  @Demo_OutputFcn, ...
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


% --- Executes just before Demo is made visible.
function Demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Demo (see VARARGIN)

% Choose default command line output for Demo
handles.output = hObject;

handles.lastPath = './';
handles.img = 0;
handles.imgRef = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Demo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, filepath] = uigetfile({'*.jpg';'*.png';'*.*'},'選擇圖片', handles.lastPath);
if filename ~= 0
    set(handles.fileNameText, 'String', filename);
    handles.lastPath = filepath;
    handles.oriimg = imread(strcat(filepath, filename));
    showPicture = true;
    alpha = 1.0;
    switch get(get(handles.imresizeButtonGroup,'SelectedObject'),'Tag')
        case 'resize01'
            alpha = 0.1;
        case 'resize02'
            alpha = .2;
        case 'resize05'
            alpha = .5;
        case 'resize08'
            alpha = .8;
        case 'resize10'
            alpha = 1.0;
    end
    
    
    handles.img = imresize(handles.oriimg, alpha);
    [M, N] = size(handles.img(:, :, 1));
    set(handles.imgSize, 'String', sprintf('%d x %d', M, N));
    if M*N > 2000*2000
        h = questdlg(sprintf('警告：圖片過大\n圖片大小 %d x %d 過大，會花費大量時間執行，確定執行嗎？', M, N), 'Yes', 'No');
        switch h
            case 'Yes'
                showPicture = true;
            case 'No'
                showPicture = false;
            otherwise
                showPicture = false;
        end
    end
    if showPicture
        [M, N] = size(handles.img(:, :, 1));
        set(handles.imgSize, 'String', sprintf('%d x %d', M, N));
        axes(handles.axes1);
        imshow(handles.img);
        guidata(hObject, handles);
    end
end
% --- Executes during object creation, after setting all properties.
function fileNameText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileNameText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in nextStepPushButton.
function nextStepPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to nextStepPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.img == 0
     warndlg({'警告', '沒有選擇原圖'});
     return
 end
 if  handles.imgRef == 0
     warndlg({'警告', '沒有選擇色彩轉換參考圖片'});
     return
 end
 
 switch get(get(handles.motionButtonGroup,'SelectedObject'),'Tag')
     case 'ehsiFirst'
         imgE = ehsiEnhancement(im2double(handles.img), 'ehsi', false);
         axes(handles.middle);
         set(handles.middleAxesText, 'String', 'eHSI 強化結果');
         imshow(imgE);
         imgH = ehsiEnhancement(im2double(handles.img), 'hsi', false);
         axes(handles.traditional);
         imshow(imgH);
         imgT = colorTransform(imgE, handles.imgRef);
         axes(handles.final);
         set(handles.finalAxesText, 'String', '強化->色彩轉換結果');
         imshow(imgT);
     case 'transformFirst'
         imgT = colorTransform(im2double(handles.img), handles.imgRef);
         axes(handles.middle);
         set(handles.middleAxesText, 'String', '色彩結果');
         imshow(imgT);
         imgH = ehsiEnhancement(imgT, 'hsi', false);
         axes(handles.traditional);
         imshow(imgH);
         imgE = ehsiEnhancement(imgT, 'ehsi', false);
         axes(handles.final);
         set(handles.finalAxesText, 'String', '轉換->色彩強化結果');
         imshow(imgE);
 end

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, filepath] = uigetfile({'*.jpg';'*.png';'*.*'},'選擇圖片', handles.lastPath);
if filename ~= 0
    set(handles.fileReferencedText, 'String', filename);
    handles.lastPath = filepath;
    handles.imgRef = imread(strcat(filepath, filename));
    axes(handles.axes3);
    imshow(handles.imgRef);
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function fileReferencedText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileReferencedText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in ehsiFirst.
function ehsiFirst_Callback(hObject, eventdata, handles)
% hObject    handle to ehsiFirst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ehsiFirst


% --- Executes during object creation, after setting all properties.
function motionButtonGroup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to motionButtonGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected object is changed in imresizeButtonGroup.
function imresizeButtonGroup_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in imresizeButtonGroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.img == 0
    return
end
    alpha = 1.0;
    switch get(get(handles.imresizeButtonGroup,'SelectedObject'),'Tag')
        case 'resize01'
            alpha = 0.1;
        case 'resize02'
            alpha = .2;
        case 'resize05'
            alpha = .5;
        case 'resize08'
            alpha = .8;
        case 'resize10'
            alpha = 1.0;
    end
    
    showPicture = true;
    handles.img = imresize(handles.oriimg, alpha);
    [M, N] = size(handles.img(:, :, 1));
    if M*N > 2000*2000
        h = questdlg(sprintf('警告：圖片過大\n圖片大小 %d x %d 過大，會花費大量時間執行，確定執行嗎？', M, N), 'Yes', 'No');
        switch h
            case 'Yes'
                showPicture = true;
            case 'No'
                showPicture = false;
            otherwise
                showPicture = false;
        end
    end
    if showPicture
        [M, N] = size(handles.img(:, :, 1));
        set(handles.imgSize, 'String', sprintf('%d x %d', M, N));
        imshow(handles.img);
        guidata(hObject, handles);
    end
