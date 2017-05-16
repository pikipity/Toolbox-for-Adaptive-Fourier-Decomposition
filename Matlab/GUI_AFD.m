function varargout = GUI_AFD(varargin)
% GUI_AFD MATLAB code for GUI_AFD.fig
%      GUI_AFD, by itself, creates a new GUI_AFD or raises the existing
%      singleton*.
%
%      H = GUI_AFD returns the handle to a new GUI_AFD or the handle to
%      the existing singleton*.
%
%      GUI_AFD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_AFD.M with the given input arguments.
%
%      GUI_AFD('Property','Value',...) creates a new GUI_AFD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_AFD_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_AFD_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_AFD

% Last Modified by GUIDE v2.5 15-May-2017 11:50:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_AFD_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_AFD_OutputFcn, ...
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


% --- Executes just before GUI_AFD is made visible.
function GUI_AFD_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_AFD (see VARARGIN)

% Choose default command line output for GUI_AFD
handles.output = hObject;
%
handles=clear_variables(handles);
handles=Plot_All(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_AFD wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function handles=clear_variables(handles)
handles.M=50;
handles.L=[];
handles.s=[];
handles.t=[];
handles.Weight=[];
handles.Base=[];
handles.dic_an=[];
handles.XX=[];
handles.YY=[];
handles.an=[];
handles.coef=[];
handles.currn=[];
handles.n=[];
handles.Bn=[];
handles.Fn=[];
handles.standard_reminder=[];
handles.reduced_reminder=[];
handles.ObjFun={};
handles.ObjFun_an=[];
handles.an_x=[];
handles.an_y=[];
handles.ReconSig=[];

function handles=Plot_an_Position(handles)
if isempty(handles.an)
    plot(0,0,'w','parent',handles.an_Position)
else
    plot(0,0,'w','parent',handles.an_Position)
    hold(handles.an_Position,'on')
    plot(real(handles.an(1:end-1)),imag(handles.an(1:end-1)),'rx','parent',handles.an_Position)
    hold(handles.an_Position,'off')
end
set(handles.an_Position,'XLim',[-1 1])
set(handles.an_Position,'YLim',[-1 1])

function handles=Fill_an_Value(handles)
if isempty(handles.an)
    set(handles.an_Value,'Data',[]);
else
    set(handles.an_Value,'Data',[handles.an_x(1:end-1).' handles.an_y(1:end-1).'.*180./pi]);
end

function handles=Plot_Input_Signal(handles)
if isempty(handles.s)
    plot(0,0,'w','parent',handles.Input_Signal_Plot)
else
    plot(handles.t,real(handles.s),'parent',handles.Input_Signal_Plot,'linewidth',3);
    set(handles.Input_Signal_Plot,'XLim',[min(handles.t) max(handles.t)])
    set(handles.Input_Signal_Plot,'YLim',[min(real(handles.s)) max(real(handles.s))])
end

function handles=Plot_Recon_Signal(handles)
if isempty(handles.ReconSig)
    plot(0,0,'w','parent',handles.Reconstructed_Signal_Plot)
else
    n=size(handles.ReconSig,1);
    plot(handles.t,real(handles.s),'r--','parent',handles.Reconstructed_Signal_Plot,'linewidth',3);
    hold(handles.Reconstructed_Signal_Plot,'on')
    plot(handles.t,real(handles.ReconSig(n,:)),'parent',handles.Reconstructed_Signal_Plot,'linewidth',3);
    set(handles.Reconstructed_Signal_Plot,'XLim',[min(handles.t) max(handles.t)])
    set(handles.Reconstructed_Signal_Plot,'YLim',[min(real(handles.s)) max(real(handles.s))])
    hold(handles.Reconstructed_Signal_Plot,'off')
end

function handles=Plot_Standard_Reminder(handles)
if isempty(handles.standard_reminder)
    plot(0,0,'w','parent',handles.Standard_Reminder_Plot)
else
    n=size(handles.standard_reminder,1);
    plot(handles.t,real(handles.standard_reminder(n,:)),'parent',handles.Standard_Reminder_Plot,'linewidth',3);
    set(handles.Standard_Reminder_Plot,'XLim',[min(handles.t) max(handles.t)])
    set(handles.Standard_Reminder_Plot,'YLim',[min(real(handles.s)) max(real(handles.s))])
end

function handles=Plot_Reduced_Reminder(handles)
if isempty(handles.reduced_reminder)
    plot(0,0,'w','parent',handles.Reduced_Reminder_Plot)
else
    n=size(handles.reduced_reminder,1);
    plot(handles.t,real(handles.reduced_reminder(n,:)),'parent',handles.Reduced_Reminder_Plot,'linewidth',3);
    set(handles.Reduced_Reminder_Plot,'XLim',[min(handles.t) max(handles.t)])
    set(handles.Reduced_Reminder_Plot,'YLim',[min(real(handles.reduced_reminder(n,:))) max(real(handles.reduced_reminder(n,:)))])
end

function handles=Plot_Objective_Function(handles)
if isempty(handles.ObjFun)
    plot(0,0,'w','parent',handles.Obj_Fun_Values_Plot)
else
    mesh(handles.XX,handles.YY,abs(handles.ObjFun{end}),'parent',handles.Obj_Fun_Values_Plot);
    set(handles.Obj_Fun_Values_Plot,'XLim',[min(min(handles.XX)) max(max(handles.XX))])
    set(handles.Obj_Fun_Values_Plot,'YLim',[min(min(handles.YY)) max(max(handles.YY))])
    xlabel(handles.Obj_Fun_Values_Plot,'|a_n|');
    ylabel(handles.Obj_Fun_Values_Plot,'\angle a_n');
end

function handles=Plot_Max(handles)
if isempty(handles.ObjFun_an)
    plot(0,0,'w','parent',handles.Find_Max_Plot)
else
    mesh(handles.XX,handles.YY,abs(handles.ObjFun{end}),'parent',handles.Find_Max_Plot);
    hold(handles.Find_Max_Plot,'on')
    n=length(handles.ObjFun_an);
    plot3(handles.an_x(n),handles.an_y(n),abs(handles.ObjFun_an(n)),'rx','parent',handles.Find_Max_Plot,'linewidth',3,'markersize',15);
    set(handles.Find_Max_Plot,'XLim',[min(min(handles.XX)) max(max(handles.XX))])
    set(handles.Find_Max_Plot,'YLim',[min(min(handles.YY)) max(max(handles.YY))])
    hold(handles.Find_Max_Plot,'off')
    xlabel(handles.Find_Max_Plot,'|a_n|');
    ylabel(handles.Find_Max_Plot,'\angle a_n');
end

function handles=Plot_Decom_Comp(handles)
if isempty(handles.Fn)
    plot(0,0,'w','parent',handles.Decomposition_Component_Plot)
else
   n=size(handles.Fn,1);
   plot(handles.t,real(handles.s),'r--','parent',handles.Decomposition_Component_Plot,'linewidth',3);
   hold(handles.Decomposition_Component_Plot,'on');
   plot(handles.t,real(handles.Fn(n,:)),'parent',handles.Decomposition_Component_Plot,'linewidth',3)
   set(handles.Decomposition_Component_Plot,'XLim',[min(handles.t) max(handles.t)])
   set(handles.Decomposition_Component_Plot,'YLim',[min(real(handles.s)) max(real(handles.s))])
   hold(handles.Decomposition_Component_Plot,'off');
end

function handles=Plot_All(handles)
handles=Plot_an_Position(handles);
handles=Plot_Input_Signal(handles);
handles=Plot_Recon_Signal(handles);
handles=Plot_Standard_Reminder(handles);
handles=Plot_Reduced_Reminder(handles);
handles=Plot_Objective_Function(handles);
handles=Plot_Max(handles);
handles=Plot_Decom_Comp(handles);
handles=Fill_an_Value(handles);

% --- Outputs from this function are returned to the command line.
function varargout = GUI_AFD_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Load_Data_Button.
function Load_Data_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Data_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
n=str2num(get(handles.Decom_Level_TXT,'String'));
set(handles.Increase_Decom_Level,'Enable','off')
set(handles.Decrease_Decom_Level,'Enable','off')
%
[fn,pn]=uigetfile({'*.mat','All Files'});
if fn==0
    %
    set(handles.Increase_Decom_Level,'Enable','on')
    if n==1
        set(handles.Decrease_Decom_Level,'Enable','off')
    else
        set(handles.Decrease_Decom_Level,'Enable','on')
    end
    %
    return;
end
waitbarh=waitbar(0,'Load Data');
k=load([pn fn]);
names=fieldnames(k);
if length(names)~=1
    close(waitbarh);
    errordlg('Please only store one variable in .mat file','Data Error');
    %
    set(handles.Increase_Decom_Level,'Enable','on')
    if n==1
        set(handles.Decrease_Decom_Level,'Enable','off')
    else
        set(handles.Decrease_Decom_Level,'Enable','on')
    end
    %
    return;
else
    eval(['k=k.' names{1} ';'])
    if size(k,1)~=1 && size(k,1)~=1
        close(waitbarh);
        errordlg('Input signal cannot be multischannel signal','Data Error');
        %
        set(handles.Increase_Decom_Level,'Enable','on')
        if n==1
            set(handles.Decrease_Decom_Level,'Enable','off')
        else
            set(handles.Decrease_Decom_Level,'Enable','on')
        end
        %
        return;
    elseif size(k,1)~=1
        k=k.';
    end
    set(handles.Data_Path_String,'String',[pn fn]);
    handles=clear_variables(handles);
    if isreal(k)
        s=hilbert(k);
    else
        s=k;
    end
    %
    waitbar(1/3,waitbarh,'Initialize Parameters');
    %
    handles.M=50;
    handles.L=0:2*pi/length(s):(2*pi-2*pi/length(s));
    handles.s=s;
    K=length(s);
    handles.t=0:2*pi/K:(2*pi-2*pi/K);
    handles.Weight=ones(K,1);
    %
    waitbar(2/3,waitbarh,'Build Dictionary');
    %
    abs_a=linspace(0,1,handles.M+1);
    abs_a=abs_a(1:end-1);
    phase_a=handles.L;
    dic_an=abs_a;
    handles.dic_an=dic_an;
    Base=zeros(length(abs_a),length(phase_a));
    for k=1:size(Base,1)
        Base(k,:)=fft(e_a(dic_an(k),exp(1j.*phase_a)),length(phase_a));
    end
    handles.Base=Base;
    %
    waitbar(3/3,waitbarh,'Store Parameters');
    [XX,YY]=meshgrid(abs_a,phase_a);
    handles.XX=XX.';
    handles.YY=YY.';
    handles.an=[];
    handles.coef=[];
    handles.currn=0;
    handles.n=str2num(get(handles.Decom_Level_TXT,'String'));
    handles.Bn=[];
    handles.Fn=[];
    handles.standard_reminder=[];
    handles.reduced_reminder=[];
    handles.ObjFun={};
    handles.ObjFun_an=[];
    handles.an_x=[];
    handles.an_y=[];
    handles.ReconSig=[];
    %
    close(waitbarh);
    %
    handles=FFT_AFD(handles);
    %
    handles=Plot_All(handles);
end
% Update handles structure
guidata(hObject, handles);
%
set(handles.Increase_Decom_Level,'Enable','on')
if n==1
    set(handles.Decrease_Decom_Level,'Enable','off')
else
    set(handles.Decrease_Decom_Level,'Enable','on')
end
%

function handles=FFT_AFD(handles)
if isempty(handles.s)
    return;
end
waitbarh=waitbar(0,'AFD');
if handles.currn-1>handles.n
    waitbar(1,waitbarh,'Reduce Decomposition Level');
    handles.currn=handles.n+1;
    handles.an=handles.an(1:handles.currn);
    handles.coef=handles.coef(1:handles.currn);
    handles.Bn=handles.Bn(1:handles.currn,:);
    handles.Fn=handles.Fn(1:handles.currn,:);
    handles.standard_reminder=handles.standard_reminder(1:handles.currn,:);
    handles.reduced_reminder=handles.reduced_reminder(1:handles.currn,:);
    handles.ObjFun=handles.ObjFun(1:handles.currn);
    handles.ObjFun_an=handles.ObjFun_an(1:handles.currn);
    handles.an_x=handles.an_x(1:handles.currn);
    handles.an_y=handles.an_y(1:handles.currn);
    handles.ReconSig=handles.ReconSig(1:handles.currn,:);
elseif handles.currn-1<handles.n
    K=length(handles.s);
    Weight=ones(K,1);
    while handles.currn<=handles.n
        handles.currn=handles.currn+1;
        %
        waitbar(handles.currn/(handles.currn+1),waitbarh,['Process Decomposition Level ' num2str(handles.currn)]);
        %
        if handles.currn==1
            handles.ReconSig(handles.currn,:)=zeros(1,length(handles.s));
            handles.standard_reminder(handles.currn,:)=handles.s;
            handles.reduced_reminder(handles.currn,:)=handles.s;
            handles.ObjFun{handles.currn}=[];
            handles.ObjFun_an(handles.currn)=0;
            handles.an_x(handles.currn)=0;
            handles.an_y(handles.currn)=0;
            handles.an(handles.currn)=0;
            handles.coef(handles.currn)=intg(handles.s,ones(size(handles.s)),Weight);
            handles.Bn(handles.currn,:)=(sqrt(1-abs(handles.an(1))^2)./(1-conj(handles.an(1))*exp(handles.t.*1i)));
            handles.Fn(handles.currn,:)=handles.coef(handles.currn).*handles.Bn(handles.currn,:);
        else
            if size(handles.Fn,1)==1
                handles.ReconSig(handles.currn,:)=handles.Fn;
            else
                handles.ReconSig(handles.currn,:)=sum(handles.Fn);
            end
            handles.standard_reminder(handles.currn,:)=handles.standard_reminder(handles.currn-1,:)-handles.Fn(handles.currn-1,:);
            e_an=e_a(handles.an(handles.currn-1),exp(1j.*handles.t));
            handles.reduced_reminder(handles.currn,:)=(handles.reduced_reminder(handles.currn-1,:)-handles.coef(handles.currn-1).*e_an).*(1-conj(handles.an(handles.currn-1)).*exp(1j.*handles.t))./(exp(1j.*handles.t)-handles.an(handles.currn-1));
            S1=ifft(repmat(fft(handles.reduced_reminder(handles.currn,:).*Weight.',length(handles.t)),size(handles.Base,1),1).*handles.Base,length(handles.t),2);
            handles.ObjFun{handles.currn}=S1;
            [S2,I1]=max(abs(S1));
            [~,I2]=max(S2);
            handles.ObjFun_an(handles.currn)=S1(I1(I2),I2);
            handles.an(handles.currn)=handles.dic_an(I1(I2)).*exp(1j.*handles.t(I2));
            handles.an_x(handles.currn)=abs(handles.an(handles.currn));
            handles.an_y(handles.currn)=handles.t(I2);
            handles.coef(handles.currn)=conj(e_a(handles.an(handles.currn),exp(handles.t.*1i))*(handles.reduced_reminder(handles.currn,:)'.*Weight))./length(handles.t);
            handles.Bn(handles.currn,:)=(sqrt(1-abs(handles.an(handles.currn))^2)./(1-conj(handles.an(handles.currn))*exp(handles.t.*1i))).*((exp(1i*handles.t)-handles.an(handles.currn-1))./(sqrt(1-abs(handles.an(handles.currn-1))^2))).*handles.Bn(handles.currn-1,:);
            handles.Fn(handles.currn,:)=handles.coef(handles.currn).*handles.Bn(handles.currn,:);
        end
    end
end
close(waitbarh);



% function Data_Path_String_Callback(hObject, eventdata, handles)
% % hObject    handle to Data_Path_String (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of Data_Path_String as text
% %        str2double(get(hObject,'String')) returns contents of Data_Path_String as a double
% 
% 
% % --- Executes during object creation, after setting all properties.
% function Data_Path_String_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to Data_Path_String (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end



function Decom_Level_TXT_Callback(hObject, eventdata, handles)
% hObject    handle to Decom_Level_TXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Decom_Level_TXT as text
%        str2double(get(hObject,'String')) returns contents of Decom_Level_TXT as a double
n=str2num(get(handles.Decom_Level_TXT,'String'));
if isempty(n)
    errordlg('Decomposition level cannot be a string','Wrong Decomposition Level');
    if isempty(handles.n)
        set(handles.Decom_Level_TXT,'String',1);
    else
        set(handles.Decom_Level_TXT,'String',num2str(handles.n));
    end
    return;
end
%
set(handles.Increase_Decom_Level,'Enable','off')
set(handles.Decrease_Decom_Level,'Enable','off')
%
n=round(str2num(get(handles.Decom_Level_TXT,'String')));
if n<1
    n=1;
end
set(handles.Decom_Level_TXT,'String',num2str(n));
%
handles.n=n;
handles=FFT_AFD(handles);
%
handles=Plot_All(handles);
% Update handles structure
guidata(hObject, handles);
%
set(handles.Increase_Decom_Level,'Enable','on')
if n==1
    set(handles.Decrease_Decom_Level,'Enable','off')
else
    set(handles.Decrease_Decom_Level,'Enable','on')
end
%


% --- Executes during object creation, after setting all properties.
function Decom_Level_TXT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Decom_Level_TXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Decrease_Decom_Level.
function Decrease_Decom_Level_Callback(hObject, eventdata, handles)
% hObject    handle to Decrease_Decom_Level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
set(handles.Increase_Decom_Level,'Enable','off')
set(handles.Decrease_Decom_Level,'Enable','off')
%
n=str2num(get(handles.Decom_Level_TXT,'String'));
n=n-1;
if n<1
    n=1;
end
set(handles.Decom_Level_TXT,'String',num2str(n));
%
handles.n=n;
handles=FFT_AFD(handles);
%
handles=Plot_All(handles);
% Update handles structure
guidata(hObject, handles);
%
set(handles.Increase_Decom_Level,'Enable','on')
if n==1
    set(handles.Decrease_Decom_Level,'Enable','off')
else
    set(handles.Decrease_Decom_Level,'Enable','on')
end
%


% --- Executes on button press in Increase_Decom_Level.
function Increase_Decom_Level_Callback(hObject, eventdata, handles)
% hObject    handle to Increase_Decom_Level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
set(handles.Increase_Decom_Level,'Enable','off')
set(handles.Decrease_Decom_Level,'Enable','off')
%
n=str2num(get(handles.Decom_Level_TXT,'String'));
n=n+1;
if n<1
    n=1;
end
set(handles.Decom_Level_TXT,'String',num2str(n));
%
handles.n=n;
handles=FFT_AFD(handles);
%
handles=Plot_All(handles);
% Update handles structure
guidata(hObject, handles);
%
set(handles.Increase_Decom_Level,'Enable','on')
if n==1
    set(handles.Decrease_Decom_Level,'Enable','off')
else
    set(handles.Decrease_Decom_Level,'Enable','on')
end
%
