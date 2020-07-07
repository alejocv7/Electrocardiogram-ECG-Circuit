function varargout = prueba(varargin)
% PRUEBA MATLAB code for prueba.fig
%      PRUEBA, by itself, creates a new PRUEBA or raises the existing
%      singleton*.
%
%      H = PRUEBA returns the handle to a new PRUEBA or the handle to
%      the existing singleton*.
%
%      PRUEBA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PRUEBA.M with the given input arguments.
%
%      PRUEBA('Property','Value',...) creates a new PRUEBA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before prueba_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to prueba_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help prueba

% Last Modified by GUIDE v2.5 14-Dec-2014 17:06:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @prueba_OpeningFcn, ...
                   'gui_OutputFcn',  @prueba_OutputFcn, ...
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


% --- Executes just before prueba is made visible.
function prueba_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to prueba (see VARARGIN)

handles.output = hObject;
guidata(hObject, handles);
ah = axes('unit', 'normalized', 'position', [0 0 1 1]);


bg = imread('foto2.jpg'); imagesc(bg);

set(ah,'handlevisibility','off','visible','off')

uistack(ah, 'bottom');

set(handles.Procesar,'enable','off')
set(handles.FC,'enable','off');
set(handles.QRS,'enable','off');


clear; clc;
% --- Outputs from this function are returned to the command line.
function varargout = prueba_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in Cargar.
function Cargar_Callback(hObject, eventdata, handles)
% hObject    handle to Cargar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Permite al usuario elegir el archivo de los datos que desea desplegar en pantalla.
set(handles.Procesar,'enable','off')
set(handles.FC,'enable','off');
set(handles.QRS,'enable','off');
set(handles.ventana,'string','latidos');
%[filename, pathname] = uigetfile({'*.dat'},'File Selector');
%archivo=[pathname filename];
filename = 'C:\Users\AleJanDro\Downloads\einthoven\ii.dat';
delimiter = '\t';
% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%[^\n\r]';

% Open the text file.
fileID = fopen(filename,'r');

% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);

% Close the text file.
fclose(fileID);

% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

% Allocate imported array to column variable names
VarName1 = dataArray{:, 1};
VarName2 = dataArray{:, 2};

% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;

xa = VarName1; 
ya = VarName2;

A = [xa ya];
% figure (1)
% plot(A)

YA = fft(ya);

xf = linspace(0,1,length(ya));
% figure (3)
% plot(xf,abs(YA));

a = fir1(100,[0.012 0.014],'stop');
y2 = filter(a,1,ya);
ECG1=y2;

%msgbox(' Archivo Listo!!','Aviso')
%Carga el archivo de datos a la variable ECG1
axes(handles.axes1)
newplot; %prepara el axes1 para una nueva gráfica
colordef black;
plot(ECG1,'g'); grid on;
% Se etiquetan los ejes y se define el tamaño de la letra
ylabel('\bf Amplitud (mV)','Fontsize',8); xlabel('\bf Muestras (ms)','Fontsize',8);
set(handles.Procesar,'enable','on'); % Se habilita el botón para procesar la señal
set(handles.ventana,'string','latidos');
handles.original=ECG1;
guidata(hObject,handles);


% --- Executes on button press in Procesar.
function Procesar_Callback(hObject, eventdata, handles)
% hObject    handle to Procesar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
newplot;
colordef black;
ECG1=handles.original;
[b,a] = butter(3, 0.06, 'low'); 
y3 = filter(b,a,ECG1);
ECG1=y3;
N=size(ECG1);
ECG=ECG1;
ECG=(ECG1-mean(ECG1))/(500);
B=[1 0 0 0 0 0 -2 0 0 0 0 0 1];
A=[1 -2 1];
s1=filter(B,A,ECG); %s1 es la señal resultante del primer filtrado
hold on; plot(s1/max(s1),'g'); grid on; %Se grafica s1
% Habilita el botón para graficar las ventanas que identican los complejos QRS
set(handles.QRS,'enable','on');
ylabel('\bf Amplitud (V)','Fontsize',8); xlabel('\bf Muestras (ms)','Fontsize',8);
handles.senial=s1;
handles.ecg=ECG;
guidata(hObject,handles);

% --- Executes on button press in QRS.
function QRS_Callback(hObject, eventdata, handles)
% hObject    handle to QRS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Filtro Pasa-altas
%Definimos las características del filtro pasa-bajas
%Sabemos que un filtro puede ser definido con un par de
%polinomios que caracterizaran
%los polos y ceros de este y así definimos A, B y C.
set(handles.FC,'enable','on');
ECG=handles.ecg;
s1=handles.senial;
B=zeros(1,33); %Comando para generar una matriz de tamaño 1* 33
B(1)=1; B(33)=-1; %Se definen el primer y ultimo elemento como 1 y -1
A=[1 -1];
C=zeros(1,17); C(17)=1;
s2=filter(C,1,s1)-filter(B,A,s1); %s2 es la señal resultante del segundo filtrado
%Filtro Derivador
%Definimos las características del filtro derivador.
B=[0.2 0.1 0 -0.1 -0.2];
s3=filter(B,A,s2); %s3 es la señal resultante del tercer filtrado
%Area bajo la curva QRS
%Gráfica para mostrar el área bajo la curva QRS
N=30
B=ones(1,N)/N;
s4=s3.^2;
s4=filter(B,1,s4);%s4 es la señal resultante del segundo filtrado
%Filtro fc (Duracion del QRS)
%En este grafico podemos visualizar a través de ventanas de tiempo la curva QRS.
axes(handles.axes2)
newplot;
plot(s4);
colordef black;
handles.segunda=s4
guidata(hObject,handles);

function FC_Callback(hObject, eventdata, handles)
% hObject    handle to FC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s4=handles.segunda;
th=max(s4);
th=th/2.6;
a=0;
for i=1:length(s4)
    if s4(i)>th
        s4(i)=1;
    else
        s4(i)=0;
    end
end
axes(handles.axes2)
plot (s4)
for i=1:length(s4)
    if s4(i)==1
        a=a;
    if s4(i-1)==0
         a=a+1;
    end
    end
end
%index = find ( diff ( sign ( diff ([0; s4(:); 0])))<0);% Detección de picos( MATLAB CENTRAL)
%li=length(index) ;
VFC=0;
if a==5
VFC=a*15
end
if a>5 && a<9
    VFC=a*9.7
end
    if a==9
    VFC=a*8.5
end% Se divide para 2 y se multiplica por 6 ya que es una muestra de 10 segundos.
if (VFC<=80)
    msgbox(' Frecuencia cardiaca normal','Aviso')
else
    msgbox(' Frecuencia cardiaca alta Taquicardia','Aviso')
end
set(handles.ventana,'string',VFC );

% --- Executes on button press in ECG.
function ECG_Callback(hObject, eventdata, handles)
% hObject    handle to ECG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ECG

axes(handles.axes1) %con esto selecciona el eje a utilizar.
hold off;
newplot;
set(handles.ECG,'value',1)

% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
axes(handles.axes2) %con esto selecciona el eje a utilizar.
hold off;
newplot;
set(handles.radiobutton4,'value',1)
set(handles.ECG,'value',0)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

tam=length(handles.original);
handles.slider1=get(hObject,'Value');
handles.slider1= handles.slider1*tam;
if handles.slider1==0
handles.slider1=handles.slider1+5; % Valor mínimo que puede adquirir el slider (0.1)
end
set(handles.axes1,'Xlim',[handles.slider1 handles.slider1+1000]);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.

usewhitebg = 1;
if usewhitebg
set(hObject,'BackgroundColor',[0, 0.502, 0.753]);
else
set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'defaultUicontrolBackgroundColor');
end
