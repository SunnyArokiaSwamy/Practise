function varargout = GUIforInput(varargin)
% GUIFORINPUT MATLAB code for GUIforInput.fig
%      GUIFORINPUT, by itself, creates a new GUIFORINPUT or raises the existing
%      singleton*.
%
%      H = GUIFORINPUT returns the handle to a new GUIFORINPUT or the handle to
%      the existing singleton*.
%
%      GUIFORINPUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIFORINPUT.M with the given input arguments.
%
%      GUIFORINPUT('Property','Value',...) creates a new GUIFORINPUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIforInput_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIforInput_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIforInput

% Last Modified by GUIDE v2.5 27-Apr-2018 20:41:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIforInput_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIforInput_OutputFcn, ...
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


% --- Executes just before GUIforInput is made visible.
function GUIforInput_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIforInput (see VARARGIN)

% Choose default command line output for GUIforInput
handles.output = hObject;

% Update handles structure
handles.negativeFlag=0;
handles.startFlag=0;

%data loaded in dataERP
load('Sub1dataERP6.mat');
handles.dataERP=dataERP;
%not erp6 data loaded in dataNotERP
load('Sub1dataNotERP6.mat') ; 
handles.dataNotERP=dataNotERP;
guidata(hObject, handles);

% UIWAIT makes GUIforInput wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIforInput_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure



varargout{1} = handles.output;
positiveIndex=1;
negativeIndex=1;
data=[];

disp('Start while loop')




% --- Executes on button press in StartBtn.
function StartBtn_Callback(hObject, eventdata, handles)
% hObject    handle to StartBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display('Start flag set...')
handles.startFlag=1;
guidata(hObject, handles);
positiveIndex=1;
negativeIndex=1;
data=[];

disp('Start while loop')
while(1)
    pause(0.01);
    guidata(hObject);

    while(handles.startFlag && ((positiveIndex-1) < size(handles.dataERP,1)))
        positiveIndex
        if(handles.negativeFlag)
            data=handles.dataNotERP(negativeIndex:negativeIndex+512-1,:);
            negativeIndex=negativeIndex+512;
						handles.negativeFlag=0;
                      disp('negative flag processed')
        else
            %pull 512x64 data points from dataERP
            data=handles.dataERP(positiveIndex:positiveIndex+512-1,:);
            positiveIndex=positiveIndex+512;
        end
        
        
        
    end
    
end



% --- Executes on button press in NegBtn.
function NegBtn_Callback(hObject, eventdata, handles)
% hObject    handle to NegBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display('Negative flag set...');
handles.negativeFlag=1;
guidata(hObject, handles);



% --- Executes on button press in PosBtn.
function PosBtn_Callback(hObject, eventdata, handles)
% hObject    handle to PosBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display('nono');


% --- Executes on button press in StopBtn.
function StopBtn_Callback(hObject, eventdata, handles)
% hObject    handle to StopBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display('Gogo');
a = 2;

