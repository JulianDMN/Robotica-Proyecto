function varargout = Lab_3(varargin)
% LAB_3 MATLAB code for Lab_3.fig
%      LAB_3, by itself, creates a new LAB_3 or raises the existing
%      singleton*.
%
%      H = LAB_3 returns the handle to a new LAB_3 or the handle to
%      the existing singleton*.
%
%      LAB_3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LAB_3.M with the given input arguments.
%
%      LAB_3('Property','Value',...) creates a new LAB_3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Lab_3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Lab_3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Lab_3

% Last Modified by GUIDE v2.5 27-Jun-2020 21:00:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Lab_3_OpeningFcn, ...
                   'gui_OutputFcn',  @Lab_3_OutputFcn, ...
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

% --- Executes just before Lab_3 is made visible.
function Lab_3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Lab_3 (see VARARGIN)

clc

% Declaración del robot
handles.l = [13.7  10.5  10.5  11]; %cm

handles.ws=handles.l(1)+handles.l(2)+handles.l(3)+handles.l(4)/2;

handles.Phant(1) = Link('revolute','a',0,'alpha',0,'d',handles.l(1),'offset',0,'modified');
handles.Phant(2) = Link('revolute','a',0,'alpha',pi/2,'d',0,'offset',pi/2,'modified');
handles.Phant(3) = Link('revolute','a',handles.l(2),'alpha',0,'d',0,'offset',0,'modified');
handles.Phant(4) = Link('revolute','a',handles.l(3),'alpha',0,'d',0,'offset',0,'modified');
handles.T=transl(handles.l(4),0,0)*[0,0,1,0;1,0,0,0;0,1,0,0;0,0,0,1];
handles.Phantom = SerialLink(handles.Phant,'name','PhantomX','tool',handles.T);
handles.theta = [pi/2 0 0 0 0 0 pi/2].';
handles.grip=[0,0,1,1,1,0,0];
handles.interp = [0 1 1 0 1 0].';
handles.pos(1,:)=[0 0 45.7];
handles.pos(2,:)=[10 -20 10];
handles.pos(3,:)=[10 -20 2.5];
handles.pos(4,:)=[10 -20 10];
handles.pos(5,:)=[20 0 10];
handles.pos(6,:)=[20 0 2.5];
handles.pos(7,:)=handles.pos(1,:);
handles.q0=[0 0 0 0];
MTH=handles.Phantom.fkine(handles.q0);
set(handles.PoseX, 'String', round(MTH(1,4),2));
set(handles.PoseY, 'String', round(MTH(2,4),2));
set(handles.PoseZ, 'String', round(MTH(3,4),2));
pos=tr2rpy([MTH(1,1),MTH(1,2),MTH(1,3);MTH(2,1),MTH(2,2),MTH(2,3);MTH(3,1),MTH(3,2),MTH(3,3)]);
set(handles.PosePt, 'String', round(rad2deg(pos(2)),2));

set(handles.Cadera, 'String', handles.q0(1));
set(handles.Hombro, 'String', handles.q0(2));
set(handles.Codo, 'String', handles.q0(3));
set(handles.Mano, 'String', handles.q0(4));
set(handles.Gripper, 'String', 0);
set(handles.Estado, 'String', 'Detenido');
axes(handles.axes1)
handles.Phantom.plot(handles.q0,'workspace',[-45 45 -45 45 -5 55], 'scale', 0.7,'noa');
%handles.Phantom.teach();
hold on
trplot(eye(4),'length',10,'frame','0','arrow','rgb');
view(30,30)

handles.tempX=0;
handles.tempY=0;
handles.tempZ=0;
handles.tempP=0;
handles.q_sel=1;

handles.i=1;
handles.au=true;

% Choose default command line output for Lab_3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Lab_3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Lab_3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Establecer.
function Establecer_Callback(hObject, eventdata, handles)
% hObject    handle to Establecer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.pos(handles.q_sel,:)=[handles.tempX,handles.tempY,handles.tempZ];
handles.theta(handles.q_sel)=handles.tempP-pi/2;
handles.pos(7,:)=handles.pos(1,:);
handles.theta(7)=handles.theta(1);
set(handles.PoseX, 'String', handles.pos(handles.q_sel,1));
set(handles.PoseY, 'String', handles.pos(handles.q_sel,2));
set(handles.PoseZ, 'String', handles.pos(handles.q_sel,3));
set(handles.PosePt, 'String', rad2deg(handles.theta(handles.q_sel)+pi/2));
guidata(hObject, handles);

% --- Executes on button press in Graficar.
function Graficar_Callback(hObject, eventdata, handles)
% hObject    handle to Graficar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.PoseX, 'String', handles.pos(handles.q_sel,1));
set(handles.PoseY, 'String', handles.pos(handles.q_sel,2));
set(handles.PoseZ, 'String', handles.pos(handles.q_sel,3));
set(handles.PosePt, 'String', rad2deg(handles.theta(handles.q_sel)-pi/2));


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function PosX_Callback(hObject, eventdata, handles)
% hObject    handle to PosX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PosX as text
%        str2double(get(hObject,'String')) returns contents of PosX as a double
val=get(hObject,'String');
val1=str2double(val);
handles.tempX=val1;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function PosX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PosX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PosY_Callback(hObject, eventdata, handles)
% hObject    handle to PosY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PosY as text
%        str2double(get(hObject,'String')) returns contents of PosY as a double
val=get(hObject,'String');
val1=str2double(val);
handles.tempY=val1;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function PosY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PosY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PosZ_Callback(hObject, eventdata, handles)
% hObject    handle to PosZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PosZ as text
%        str2double(get(hObject,'String')) returns contents of PosZ as a double
val=get(hObject,'String');
val1=str2double(val);
handles.tempZ=val1;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function PosZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PosZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Pitch_Callback(hObject, eventdata, handles)
% hObject    handle to Pitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Pitch as text
%        str2double(get(hObject,'String')) returns contents of Pitch as a double
val=get(hObject,'String');
val1=str2double(val);
handles.tempP=deg2rad(val1);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Pitch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PSelect.
function PSelect_Callback(hObject, eventdata, handles)
% hObject    handle to PSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str=get(hObject,'String');
val=get(hObject,'Value');

switch str{val}
    case 'Home'
        handles.q_sel=1;
    case 'Aproximación'
        handles.q_sel=2;
    case 'Recogida'
        handles.q_sel=3;
    case 'Elevación'
        handles.q_sel=4;
    case 'Desplazamiento'
        handles.q_sel=5;
    case 'Entrega'
        handles.q_sel=6;
end
set(handles.PoseX, 'String', handles.pos(handles.q_sel,1));
set(handles.PoseY, 'String', handles.pos(handles.q_sel,2));
set(handles.PoseZ, 'String', handles.pos(handles.q_sel,3));
set(handles.PosePt, 'String', rad2deg(handles.theta(handles.q_sel)-pi/2));
guidata(hObject,handles);

% Hints: contents = cellstr(get(hObject,'String')) returns PSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PSelect


% --- Executes during object creation, after setting all properties.
function PSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GraficarTodo.
function GraficarTodo_Callback(hObject, eventdata, handles)
% hObject    handle to GraficarTodo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.au==true
    clc
    rosshutdown
    rosinit; %Conexión con el nodo maestro

    pf = getpose(handles.pos,handles.theta);
    rz = rotz(-pi/2);
    pf_z = rz*pf(:,1:3).';
    pf_p = rz*pf(:,4:6).';
    pf = [pf_z.' pf_p.'];
    n = 8;
    qs = calc_tray(handles.q0,pf,handles.interp,handles.grip,n);
    handles.q0=qs(2,:);
    ps = zeros(size(qs,1),6);
    for i = 1:size(qs,1)
        p = handles.Phantom.fkine([qs(i,1),qs(i,2),qs(i,3),qs(i,4)]);
        ps(i,:) = [p(1:3,3).' p(1:3,4).'];
    end
    % Recepción de la posición del robot
    sub=rossubscriber('Phantom_sim/joint_states'); %Creación del subscrptor
    pause(1);
    A=sub.LatestMessage.Position; %Arreglo con los valores del mensaje
    set(handles.Estado, 'String', 'Corriendo');

    % Inicializador del publicador
    j1=rospublisher('Phantom_sim/joint1_position_controller/command','std_msgs/Float64'); %creación publicador
    j2=rospublisher('Phantom_sim/joint2_position_controller/command','std_msgs/Float64'); %creación publicador
    j3=rospublisher('Phantom_sim/joint3_position_controller/command','std_msgs/Float64'); %creación publicador
    j4=rospublisher('Phantom_sim/joint4_position_controller/command','std_msgs/Float64'); %creación publicador
    j5=rospublisher('Phantom_sim/joint5_position_controller/command','std_msgs/Float64'); %creación publicador
    j6=rospublisher('Phantom_sim/joint6_position_controller/command','std_msgs/Float64'); %creación publicador
    ls=qs(1,:);

    for i = handles.i:size(qs,1)
        msg1=rosmessage(j1); %Creación del mensaje
        msg2=rosmessage(j2); %Creación del mensaje
        msg3=rosmessage(j3); %Creación del mensaje
        msg4=rosmessage(j4); %Creación del mensaje
        msg5=rosmessage(j5); %Creación del mensaje
        msg6=rosmessage(j6); %Creación del mensaje
        msg1.Data=qs(i,1);
        msg2.Data=qs(i,2);
        msg3.Data=qs(i,3);
        msg4.Data=qs(i,4);
        msg5.Data=qs(i,5);
        msg6.Data=qs(i,5);
        while ~(round(A(1))==round(qs(i,1))&&round(A(5))==round(qs(i,2))&&round(A(2))==round(qs(i,3))&&round(A(6))==round(qs(i,4)))

            %axes(handles.axes1)
            %handles.Phantom.plot([qs(i,1) qs(i,2) qs(i,3) qs(i,4)],'workspace',[-45 45 -45 45 -5 55], 'scale', 0.7,'noa');
            %pause(1)
            
            send(j1,msg1)
            send(j2,msg2)
            send(j3,msg3)
            send(j4,msg4)
            A=sub.LatestMessage.Position; %Arreglo con los valores del mensaje
        end
        if (ls(5)~=qs(i,5))
            if qs(i,5)~=0
                send(j1,msg1)
                send(j2,msg2)
                send(j3,msg3)
                send(j4,msg4)
            end
            pause(2)
            send(j5,msg5)
            send(j6,msg6)
            pause(0.5)
        end
        send(j5,msg5)
        send(j6,msg6)
        send(j1,msg1)
        send(j2,msg2)
        send(j3,msg3)
        send(j4,msg4)
        MTH=handles.Phantom.fkine([A(1),A(5),A(2),A(6)]);
        set(handles.PoseX, 'String', round(MTH(1,4),2));
        set(handles.PoseY, 'String', round(MTH(2,4),2));
        set(handles.PoseZ, 'String', round(MTH(3,4),2));
        pos=tr2rpy([MTH(1,1),MTH(1,2),MTH(1,3);MTH(2,1),MTH(2,2),MTH(2,3);MTH(3,1),MTH(3,2),MTH(3,3)]);
        set(handles.PosePt, 'String', round(rad2deg(pos(3)),2));

        set(handles.Cadera, 'String', round(A(1),2));
        set(handles.Hombro, 'String', round(A(5),2));
        set(handles.Codo, 'String', round(A(2),2));
        set(handles.Mano, 'String', round(A(6),2));
        set(handles.Gripper, 'String', round(A(3),2));
        handles.i=i;
        guidata(hObject,handles);
        ls=qs(i,:);
    end
    i = size(qs,1);
    msg1=rosmessage(j1); %Creación del mensaje
    msg2=rosmessage(j2); %Creación del mensaje
    msg3=rosmessage(j3); %Creación del mensaje
    msg4=rosmessage(j4); %Creación del mensaje
    msg5=rosmessage(j5); %Creación del mensaje
    msg6=rosmessage(j6); %Creación del mensaje
    msg1.Data=qs(i,1);
    msg2.Data=qs(i,2);
    msg3.Data=qs(i,3);
    msg4.Data=qs(i,4);
    msg5.Data=0;
    msg6.Data=0;

    send(j1,msg1)
    send(j2,msg2)
    send(j3,msg3)
    send(j4,msg4)
    send(j5,msg5)
    send(j6,msg5)
    pause(0.5)
    A=sub.LatestMessage.Position; %Arreglo con los valores del mensaje
    MTH=handles.Phantom.fkine(round([A(1),A(5),A(2),A(6)]));
    set(handles.PoseX, 'String', round(MTH(1,4),2));
    set(handles.PoseY, 'String', round(MTH(2,4),2));
    set(handles.PoseZ, 'String', round(MTH(3,4),2));
    pos=tr2rpy([MTH(1,1),MTH(1,2),MTH(1,3);MTH(2,1),MTH(2,2),MTH(2,3);MTH(3,1),MTH(3,2),MTH(3,3)]);
    set(handles.PosePt, 'String', round(rad2deg(pos(3)),2));

    set(handles.Cadera, 'String', round(A(1),2));
    set(handles.Hombro, 'String', round(A(5),2));
    set(handles.Codo, 'String', round(A(2),2));
    set(handles.Mano, 'String', round(A(6),2));
    set(handles.Gripper, 'String', round(A(3),2));
    rosshutdown
    handles.i=1;
    set(handles.Estado, 'String', 'Detenido');
    guidata(hObject,handles);
end




function PoseX_Callback(hObject, eventdata, handles)
% hObject    handle to PoseX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PoseX as text
%        str2double(get(hObject,'String')) returns contents of PoseX as a double


% --- Executes during object creation, after setting all properties.
function PoseX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PoseX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PoseY_Callback(hObject, eventdata, handles)
% hObject    handle to PoseY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PoseY as text
%        str2double(get(hObject,'String')) returns contents of PoseY as a double


% --- Executes during object creation, after setting all properties.
function PoseY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PoseY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PoseZ_Callback(hObject, eventdata, handles)
% hObject    handle to PoseZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PoseZ as text
%        str2double(get(hObject,'String')) returns contents of PoseZ as a double


% --- Executes during object creation, after setting all properties.
function PoseZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PoseZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PosePt_Callback(hObject, eventdata, handles)
% hObject    handle to PosePt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PosePt as text
%        str2double(get(hObject,'String')) returns contents of PosePt as a double


% --- Executes during object creation, after setting all properties.
function PosePt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PosePt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Parada.
function Parada_Callback(hObject, eventdata, handles)
% hObject    handle to Parada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Estado, 'String', 'Detenido');
clc
rosshutdown
rosinit; %Conexión con el nodo maestro
sub=rossubscriber('Phantom_sim/joint_states'); %Creación del subscrptor
pause(1);
A=sub.LatestMessage.Position; %Arreglo con los valores del mensaje
MTH=handles.Phantom.fkine(round([A(1),A(5),A(2),A(6)]));
set(handles.PoseX, 'String', round(MTH(1,4),2));
set(handles.PoseY, 'String', round(MTH(2,4),2));
set(handles.PoseZ, 'String', round(MTH(3,4),2));
pos=tr2rpy([MTH(1,1),MTH(1,2),MTH(1,3);MTH(2,1),MTH(2,2),MTH(2,3);MTH(3,1),MTH(3,2),MTH(3,3)]);
set(handles.PosePt, 'String', round(rad2deg(pos(3)),2));

set(handles.Cadera, 'String', round(A(1),2));
set(handles.Hombro, 'String', round(A(5),2));
set(handles.Codo, 'String', round(A(2),2));
set(handles.Mano, 'String', round(A(6),2));
set(handles.Gripper, 'String', round(A(3),2));
rosshutdown
guidata(hObject,handles);


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1 rosshutdown
if handles.au==false
    rosinit; %ConexiÃ³n con el nodo maestro

    sub=rossubscriber('Phantom_sim/joint_states'); %Creación del subscrptor
    pause(1);
    A=sub.LatestMessage.Position; %Arreglo con los valores del mensaje
    
    
    j1=rospublisher('Phantom_sim/joint1_position_controller/command','std_msgs/Float64'); %Creación publicador
    j2=rospublisher('Phantom_sim/joint2_position_controller/command','std_msgs/Float64'); %Creación publicador
    j3=rospublisher('Phantom_sim/joint3_position_controller/command','std_msgs/Float64'); %Creación publicador
    j4=rospublisher('Phantom_sim/joint4_position_controller/command','std_msgs/Float64'); %Creación publicador
    j5=rospublisher('Phantom_sim/joint5_position_controller/command','std_msgs/Float64'); %Creación publicador
    j6=rospublisher('Phantom_sim/joint6_position_controller/command','std_msgs/Float64'); %Creación publicador

    q1=[0 0];
    q2=[0 0];
    q3=[0 0];
    q4=[0 0];
    q5=[0 0];
                
    while  handles.au==false;
        set(handles.Estado, 'String', 'Corriendo(M)');
         

        joy = vrjoystick(1);
        Mover1 = axis(joy, 1);
        Mover2 = axis(joy, 2);
        Mover3 = axis(joy, 4);
        Mover4 = axis(joy, 5);
        MovG = button(joy, 1);

        a11=q1(2)-15*Mover1;
        a12=q1(2);
        a21=q2(2)-15*Mover2;
        a22=q2(2);
        a31=q3(2)-15*Mover3;
        a32=q3(2);
        a41=q4(2)-15*Mover4;
        a42=q4(2);

        if MovG==1
            a51=q5(2)+3;
            a52=q5(2);
            else 
            a51=q5(2);
            a52=q5(2);
        end
            q1=[a12 a11];
            q2=[a22 a21];
            q3=[a32 a31];
            q4=[a42 a41];
            q5=[a51 a52];
            q=[deg2rad(q1) deg2rad(q2) deg2rad(q3) deg2rad(q4) q5];
                for i=1:2

                    q=[deg2rad(q1(i)) deg2rad(q2(i)) deg2rad(q3(i)) deg2rad(q4(i)) q5];
                    msg1=rosmessage(j1); %Creación del mensaje
                    msg2=rosmessage(j2); %Creación del mensaje
                    msg3=rosmessage(j3); %Creación del mensaje
                    msg4=rosmessage(j4); %Creación del mensaje
                    msg4=rosmessage(j4); %Creación del mensaje
                    msg5=rosmessage(j5); %Creación del mensaje
                    msg6=rosmessage(j5); %Creación del mensaje
                    msg1.Data=q(1);
                    msg2.Data=q(2);
                    msg3.Data=q(3);
                    msg4.Data=q(4);
                    msg5.Data=q(5);
                    msg6.Data=q(5);
                    send(j1,msg1)
                    send(j2,msg2)
                    send(j3,msg3)
                    send(j4,msg4)
                    send(j5,msg5)
                    send(j6,msg5)
     
                    pause(.2);
                 
                    A=sub.LatestMessage.Position; %Arreglo con los valores del mensaje
                    MTH=handles.Phantom.fkine(round([A(1),A(5),A(2),A(6)]));
                    set(handles.PoseX, 'String', round(MTH(1,4),2));
                    set(handles.PoseY, 'String', round(MTH(2,4),2));
                    set(handles.PoseZ, 'String', round(MTH(3,4),2));
                    pos=tr2rpy([MTH(1,1),MTH(1,2),MTH(1,3);MTH(2,1),MTH(2,2),MTH(2,3);MTH(3,1),MTH(3,2),MTH(3,3)]);
                    set(handles.PosePt, 'String', round(rad2deg(pos(3)),2));

                    set(handles.Cadera, 'String', round(A(1),2));
                    set(handles.Hombro, 'String', round(A(5),2));
                    set(handles.Codo, 'String', round(A(2),2));
                    set(handles.Mano, 'String', round(A(6),2));
                    set(handles.Gripper, 'String', round(A(3),2));

                    guidata(hObject,handles);
                end
                
                guidata(hObject,handles);
    end
    guidata(hObject,handles);        

end



function Cadera_Callback(hObject, eventdata, handles)
% hObject    handle to Cadera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Cadera as text
%        str2double(get(hObject,'String')) returns contents of Cadera as a double


% --- Executes during object creation, after setting all properties.
function Cadera_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cadera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Hombro_Callback(hObject, eventdata, handles)
% hObject    handle to Hombro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Hombro as text
%        str2double(get(hObject,'String')) returns contents of Hombro as a double


% --- Executes during object creation, after setting all properties.
function Hombro_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Hombro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Codo_Callback(hObject, eventdata, handles)
% hObject    handle to Codo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Codo as text
%        str2double(get(hObject,'String')) returns contents of Codo as a double


% --- Executes during object creation, after setting all properties.
function Codo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Codo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Mano_Callback(hObject, eventdata, handles)
% hObject    handle to Mano (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Mano as text
%        str2double(get(hObject,'String')) returns contents of Mano as a double


% --- Executes during object creation, after setting all properties.
function Mano_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mano (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Gripper_Callback(hObject, eventdata, handles)
% hObject    handle to Gripper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Gripper as text
%        str2double(get(hObject,'String')) returns contents of Gripper as a double


% --- Executes during object creation, after setting all properties.
function Gripper_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Gripper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO) 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes when selected object is changed in uibuttongroup3.
function uibuttongroup3_SelectionChangedFcn(hObject, eventdata, handles)
if hObject == handles.radiobutton1
    set(handles.salida, 'String', 'Manual');
    handles.au=false;
elseif hObject==handles.radiobutton2
    set(handles.salida, 'String', 'Automático');
    handles.au=true;
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Estado_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Estado (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function salida_CreateFcn(hObject, eventdata, handles)
% hObject    handle to salida (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
