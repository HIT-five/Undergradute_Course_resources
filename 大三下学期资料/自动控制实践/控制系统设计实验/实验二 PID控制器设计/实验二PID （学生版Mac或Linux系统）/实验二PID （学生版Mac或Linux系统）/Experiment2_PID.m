
function varargout = Experiment2_PID(varargin)
% EXPERIMENT2_PID MATLAB code for Experiment2_PID.fig
%      EXPERIMENT2_PID, by itself, creates a new EXPERIMENT2_PID or raises the existing
%      singleton*.
%
%      H = EXPERIMENT2_PID returns the handle to a new EXPERIMENT2_PID or the handle to
%      the existing singleton*.
%
%      EXPERIMENT2_PID('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPERIMENT2_PID.M with the given input arguments.
%
%      EXPERIMENT2_PID('Property','Value',...) creates a new EXPERIMENT2_PID or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Experiment2_PID_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Experiment2_PID_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Experiment2_PID

% Last Modified by GUIDE v2.5 21-Apr-2020 21:15:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Experiment2_PID_OpeningFcn, ...
                   'gui_OutputFcn',  @Experiment2_PID_OutputFcn, ...
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


% --- Executes just before Experiment2_PID is made visible.
function Experiment2_PID_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Experiment2_PID (see VARARGIN)

% Choose default command line output for Experiment2_PID
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Experiment2_PID wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Experiment2_PID_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ref_get.
function ref_get_Callback(hObject, eventdata, handles)  %输入控制器参数变量，将参数导入到workspace中
% hObject    handle to ref_get (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Kp1 = str2num(get(handles.Kp_ref,'string'));
Ki1 = str2num(get(handles.Ki_ref,'string'));
Kd1 = str2num(get(handles.Kd_ref,'string'));
filname = 'ref1.mat';
save ('ref1.mat','Kp1','Ki1','Kd1');
load ('ref1.mat');



function Kp_ref_Callback(hObject, eventdata, handles)
% hObject    handle to Kp_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Kp_ref as text
%        str2double(get(hObject,'String')) returns contents of Kp_ref as a double


% --- Executes during object creation, after setting all properties.
function Kp_ref_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Kp_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ki_ref_Callback(hObject, eventdata, handles)
% hObject    handle to Ki_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ki_ref as text
%        str2double(get(hObject,'String')) returns contents of Ki_ref as a double


% --- Executes during object creation, after setting all properties.
function Ki_ref_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ki_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Kd_ref_Callback(hObject, eventdata, handles)
% hObject    handle to Kd_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Kd_ref as text
%        str2double(get(hObject,'String')) returns contents of Kd_ref as a double


% --- Executes during object creation, after setting all properties.
function Kd_ref_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Kd_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in data_plot.
function data_plot_Callback(hObject, eventdata, handles)
% hObject    handle to data_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global y;
    plot(handles.scope,(0:0.002:5),sin(0:0.002:5));
    xlabel('时间/s');
    ylabel('位置/°');


% --- Executes on button press in student_num_get.
function student_num_get_Callback(hObject, eventdata, handles)
% hObject    handle to student_num_get (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
studentID = str2num (get(handles.edit_student_num,'string'));
save ('ref1.mat','studentID');


function edit_student_num_Callback(hObject, eventdata, handles)
% hObject    handle to edit_student_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_student_num as text
%        str2double(get(hObject,'String')) returns contents of edit_student_num as a double


% --- Executes during object creation, after setting all properties.
function edit_student_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_student_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sim_start.
function sim_start_Callback(hObject, eventdata, handles)
% hObject    handle to sim_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sim('Experiment2_PID_model');
