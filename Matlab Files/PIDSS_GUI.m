function varargout = PIDSS_GUI(varargin)
% PIDSS_GUI MATLAB code for PIDSS_GUI.fig
%      PIDSS_GUI, by itself, creates a new PIDSS_GUI or raises the existing
%      singleton*.
%
%      H = PIDSS_GUI returns the handle to a new PIDSS_GUI or the handle to
%      the existing singleton*.
%
%      PIDSS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PIDSS_GUI.M with the given input arguments.
%
%      PIDSS_GUI('Property','Value',...)  a new PIDSS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PIDSS_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PIDSS_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PIDSS_GUI

% Last Modified by GUIDE v2.5 24-Sep-2018 17:02:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PIDSS_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @PIDSS_GUI_OutputFcn, ...
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


% --- Executes just before PIDSS_GUI is made visible.
function PIDSS_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PIDSS_GUI (see VARARGIN)

% Choose default command line output for PIDSS_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PIDSS_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


axis([0 500 0 500]);
delete(instrfind({'Port'},{'COM4'}))
clear a;
global a error counter ITerm lastTemp lastError Output Power kp ki kd R1 c1 c2 c3
a = arduino('COM4', 'uno');

Power = 0;
error = 0;
counter = 18;
ITerm = 0;
lastTemp = 0;
lastError = 0;
Output = 0;
%tNew = 0;
%tOld = 0;
kp = 2;
ki = 0.005;
kd = .1; 

R1 = 1300;
c1 = 0.023026952;
c2 = -0.006029724;
c3 = 0.000068286;


% --- Outputs from this function are returned to the command line.
function varargout = PIDSS_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function TempField_Callback(hObject, eventdata, handles)
% hObject    handle to TempField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TempField as text
%        str2double(get(hObject,'String')) returns contents of TempField as a double

handles.TempString=get(hObject,'String');
handles.Temp=str2double(handles.TempString);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function TempField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TempField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SetButton.
function SetButton_Callback(hObject, eventdata, handles)
% hObject    handle to SetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global a error counter ITerm lastTemp lastError Output Power kp ki kd R1 c1 c2 c3
Setpoint = handles.Temp;
x = 0;

while 1
    %tNew = toc;
    
    V = readVoltage(a,'A0');
    logR2 = log(R1 * (5 / V - 1.0));
    T = (1.0 / (c1 + c2*logR2 + c3*logR2*logR2*logR2));
    T = T - 273.15;
%     if (T >= Setpoint)
%         break
%     end
    
    [m,n] = size(x);
    if (n==500)
        x=0;
    end
    x = [x,T];
    plot(x, 'LineWidth',2); grid on;
    axis([0 500 0 500]);
    pause(0.0001);
    
%     stop = readDigitalPin(a,'D2');
%     if (stop == 1)
%         writeDigitalPin(a,'D7',0);
%         break
%     end
    
    if (counter == 19)
        counter = 0;
        
        error = Setpoint - T;
        ITerm = ITerm +(ki * error);
        if(ITerm >= 20)
            ITerm = 20;
        elseif(ITerm < 0)
            ITerm = 0;    
        end
        dInput = (error - lastError);

        Output = kp * error + ITerm + kd * dInput;
        if(Output > 20)
            Output = 20;
        elseif(Output < 0)
            Output = 0;
        end
        lastError = error;
        lastTemp = T;
        Power = Output*5 
        
        writeDigitalPin(a,'D7',1);
    end

%     if (tNew - tOld > 0.05)        
    counter = counter + 1;
    if (counter >= Output)
        writeDigitalPin(a,'D7',0);
    end
%     tOld = tNew;
%     end
end
