function varargout = plusTipParamTest(varargin)
% PLUSTIPPARAMTEST M-file for plusTipParamTest.fig
%      PLUSTIPPARAMTEST, by itself, creates a new PLUSTIPPARAMTEST or raises the existing
%      singleton*.
%
%      H = PLUSTIPPARAMTEST returns the handle to a new PLUSTIPPARAMTEST or the handle to
%      the existing singleton*.
%
%      PLUSTIPPARAMTEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLUSTIPPARAMTEST.M with the given input arguments.
%
%      PLUSTIPPARAMTEST('Property','Value',...) creates a new PLUSTIPPARAMTEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plusTipParamTest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plusTipParamTest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plusTipParamTest

% Last Modified by GUIDE v2.5 12-Sep-2009 11:04:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plusTipParamTest_OpeningFcn, ...
                   'gui_OutputFcn',  @plusTipParamTest_OutputFcn, ...
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


% --- Executes just before plusTipParamTest is made visible.
function plusTipParamTest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plusTipParamTest (see VARARGIN)

% Choose default command line output for plusTipParamTest
handles.output = hObject;

handles.projData=[];
handles.secPerFrame=[];
handles.pixSizeNm=[];

handles.timeWindowDef=10;
handles.minRadiusDef=3;
handles.maxRadiusDef=6;
handles.maxFAngleDef=30;
handles.maxBAngleDef=10;
handles.maxShrinkFactorDef=1.5;
handles.fluctRadDef=1.5;

handles.timeWindowRange=4:2:30;
handles.minRadiusRange=3:1:5;
handles.maxRadiusRange=5:1:8;
handles.maxFAngleRange=10:10:40;
handles.maxBAngleRange=5:5:15;
handles.maxShrinkFactorRange=0.5:0.5:1.5;
handles.fluctRadRange=1.0:0.5:3.0;




% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plusTipParamTest wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plusTipParamTest_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function timeWindowDef_Callback(hObject, eventdata, handles)
% hObject    handle to timeWindowDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeWindowDef as text
%        str2double(get(hObject,'String')) returns contents of timeWindowDef as a double
handles.timeWindowDef=str2num(get(hObject,'String'))';
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function timeWindowDef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeWindowDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minRadiusDef_Callback(hObject, eventdata, handles)
% hObject    handle to minRadiusDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minRadiusDef as text
%        str2double(get(hObject,'String')) returns contents of minRadiusDef as a double
handles.minRadiusDef=str2num(get(hObject,'String'))';
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function minRadiusDef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minRadiusDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxRadiusDef_Callback(hObject, eventdata, handles)
% hObject    handle to maxRadiusDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxRadiusDef as text
%        str2double(get(hObject,'String')) returns contents of maxRadiusDef as a double
handles.maxRadiusDef=str2num(get(hObject,'String'))';
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maxRadiusDef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxRadiusDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxFAngleDef_Callback(hObject, eventdata, handles)
% hObject    handle to maxFAngleDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxFAngleDef as text
%        str2double(get(hObject,'String')) returns contents of maxFAngleDef as a double
handles.maxFAngleDef=str2num(get(hObject,'String'))';
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maxFAngleDef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxFAngleDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxBAngleDef_Callback(hObject, eventdata, handles)
% hObject    handle to maxBAngleDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxBAngleDef as text
%        str2double(get(hObject,'String')) returns contents of maxBAngleDef as a double
handles.maxBAngleDef=str2num(get(hObject,'String'))';
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maxBAngleDef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxBAngleDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function timeWindowRange_Callback(hObject, eventdata, handles)
% hObject    handle to timeWindowRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeWindowRange as text
%        str2double(get(hObject,'String')) returns contents of timeWindowRange as a double
handles.timeWindowRange=str2num(get(hObject,'String'))';
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function timeWindowRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeWindowRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minRadiusRange_Callback(hObject, eventdata, handles)
% hObject    handle to minRadiusRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minRadiusRange as text
%        str2double(get(hObject,'String')) returns contents of minRadiusRange as a double
handles.minRadiusRange=str2num(get(hObject,'String'))';
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function minRadiusRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minRadiusRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxRadiusRange_Callback(hObject, eventdata, handles)
% hObject    handle to maxRadiusRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxRadiusRange as text
%        str2double(get(hObject,'String')) returns contents of maxRadiusRange as a double
handles.maxRadiusRange=str2num(get(hObject,'String'))';
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maxRadiusRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxRadiusRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxFAngleRange_Callback(hObject, eventdata, handles)
% hObject    handle to maxFAngleRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxFAngleRange as text
%        str2double(get(hObject,'String')) returns contents of maxFAngleRange as a double
handles.maxFAngleRange=str2num(get(hObject,'String'))';
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maxFAngleRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxFAngleRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxBAngleRange_Callback(hObject, eventdata, handles)
% hObject    handle to maxBAngleRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxBAngleRange as text
%        str2double(get(hObject,'String')) returns contents of maxBAngleRange as a double
handles.maxBAngleRange=str2num(get(hObject,'String'))';
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maxBAngleRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxBAngleRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function frameRateEdit_Callback(hObject, eventdata, handles)
% hObject    handle to frameRateEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frameRateEdit as text
%        str2double(get(hObject,'String')) returns contents of
%        frameRateEdit as a double
handles.secPerFrame=str2num(get(hObject,'String'))';
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function frameRateEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameRateEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pixelSizeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to pixelSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixelSizeEdit as text
%        str2double(get(hObject,'String')) returns contents of pixelSizeEdit as a double
handles.pixSizeNm=str2num(get(hObject,'String'))';
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function pixelSizeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixelSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxShrinkFactorDef_Callback(hObject, eventdata, handles)
% hObject    handle to maxShrinkFactorDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxShrinkFactorDef as text
%        str2double(get(hObject,'String')) returns contents of maxShrinkFactorDef as a double
handles.maxShrinkFactorDef=str2num(get(hObject,'String'))';
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maxShrinkFactorDef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxShrinkFactorDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxShrinkFactorRange_Callback(hObject, eventdata, handles)
% hObject    handle to maxShrinkFactorRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxShrinkFactorRange as text
%        str2double(get(hObject,'String')) returns contents of maxShrinkFactorRange as a double
handles.maxShrinkFactorRange=str2num(get(hObject,'String'))';
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maxShrinkFactorRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxShrinkFactorRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fluctRadDef_Callback(hObject, eventdata, handles)
% hObject    handle to fluctRadDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fluctRadDef as text
%        str2double(get(hObject,'String')) returns contents of fluctRadDef as a double
handles.fluctRadDef=str2num(get(hObject,'String'))';
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function fluctRadDef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fluctRadDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fluctRadRange_Callback(hObject, eventdata, handles)
% hObject    handle to fluctRadRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fluctRadRange as text
%        str2double(get(hObject,'String')) returns contents of fluctRadRange as a double
handles.fluctRadRange=str2num(get(hObject,'String'))';
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function fluctRadRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fluctRadRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in getProjPush.
function getProjPush_Callback(hObject, eventdata, handles)
% hObject    handle to getProjPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=plusTipGuiSwitch(hObject,eventdata,handles,'getProjPush');

if ~isempty(handles.projList)
    % here we filter out any sub-directories
    a=struct2cell(handles.projList);
    a=a(2,:)';
    a=sort(a);
    b=cellfun(@isempty, strfind(a,'sub'));
    a=a(b);
    
    % check for existence of projData in meta folder - if it's not there,
    % the project has not been tracked/processed, so we cannot visualize it
    b=zeros(length(a),1);
    for i=1:length(a)
        b(i)=exist([formatPath(a{i}) filesep 'meta' filesep 'projData.mat'],'file')==2;
    end
    a=a(logical(b));

    % allow only one project to be selected
    [selection,selectionList]=listSelectGUI(a,1,'move',1);

    % if a project was selected, save projData info and get data
    if ~isempty(selection)
        handles.dataDir=formatPath(selectionList{1,1});
        p=load([handles.dataDir filesep 'meta' filesep 'projData.mat']);
        handles.projData=p.projData;
    else
        msgbox('No projects selected or tracking has not been completed.')
        handles.dataDir=[];
        handles.projData=[];
    end
else
    msgbox('No projects selected.')
    handles.dataDir=[];
    handles.projData=[];
end
guidata(hObject, handles);


% --- Executes on button press in startPush.
function startPush_Callback(hObject, eventdata, handles)
% hObject    handle to startPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

parametersToTest{1,1}='minRadius';
parametersToTest{1,2}=handles.minRadiusDef;
parametersToTest{1,3}=handles.minRadiusRange;

parametersToTest{2,1}='maxRadius';
parametersToTest{2,2}=handles.maxRadiusDef;
parametersToTest{2,3}=handles.maxRadiusRange;


parametersToTest{3,1}='timeWindow';
parametersToTest{3,2}=handles.timeWindowDef;
parametersToTest{3,3}=handles.timeWindowRange;

parametersToTest{4,1}='maxFAngle';
parametersToTest{4,2}=handles.maxFAngleDef;
parametersToTest{4,3}=handles.maxFAngleRange;

parametersToTest{5,1}='maxBAngle';
parametersToTest{5,2}=handles.maxBAngleDef;
parametersToTest{5,3}=handles.maxBAngleRange;

parametersToTest{6,1}='maxShrinkFactor';
parametersToTest{6,2}=handles.maxShrinkFactorDef;
parametersToTest{6,3}=handles.maxShrinkFactorRange;

parametersToTest{7,1}='fluctRad';
parametersToTest{7,2}=handles.fluctRadDef;
parametersToTest{7,3}=handles.fluctRadRange;


if isempty(handles.projData)
    h=errordlg('No project selected.');
    uiwait(h);
    return
end
if isempty(handles.secPerFrame)
    h=errordlg('Please enter frame rate.');
    uiwait(h);
    return
end
if isempty(handles.pixSizeNm)
    h=errordlg('Please enter pixel size.');
    uiwait(h);
    return
end


[allData]=plusTipParameterTest(handles.projData,parametersToTest,...
    handles.secPerFrame,handles.pixSizeNm);

disp('Finished!')


% --- Executes on button press in getHelpPush.
function getHelpPush_Callback(hObject, eventdata, handles)
% hObject    handle to getHelpPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open plusTipParamTest_README.txt

