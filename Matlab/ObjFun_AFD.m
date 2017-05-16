function [XX,YY,ObjFun,an_x,an_y,ObjFun_an,reduced_reminder,standard_reminder]=ObjFun_AFD(s,max_level,M,varargin)
% Calculate objective function values of the AFD in each decomposition level
%
% [XX,YY,ObjFun,an_x,an_y,ObjFun_an]=ObjFun_AFD(s,max_level,M)
% [XX,YY,ObjFun,an_x,an_y,ObjFun_an]=ObjFun_AFD(s,max_level,M,L)
%
% Desciptions:
%   (1) [XX,YY,ObjFun,an_x,an_y,ObjFun_an]=ObjFun_AFD(s,max_level,M): Calculate 
%       objectie function values and locate maximum objective fuinction values 
%       in each decomposition level. The magnitude searching dictionary of an 
%       generated based on M. The phase searching dictionary of an gnerated according 
%       to the length of the signal s.
%   (2) [XX,YY,ObjFun,an_x,an_y,ObjFun_an]=ObjFun_AFD(s,max_level,M,L): Same as (1) but the phase
%       searching dictionary of an generated according to L.
%
% Inputs:
%   s: 1*K pocessed discrete signal
%   max_level: maximum decomposition level
%   M: if it is a integer number, it is the maximum number of the magnitude
%      values of a_n in the searching dictionary, and the dictionary of the
%      magnitude values is unique distributed in [0,1).
%      if it is an array, it is the dictionary of the magnitude values.
%   L: if it is a integer number, it is the maximum number of the phase
%      values of a_n in the searching dictionary, and the dictionary of the
%      phase values is unique distributed in [0,2*pi).
%
% Outputs:
%   XX: X axis for plotting objective functions
%   YY: Y axis for plotting objective functions
%   ObjFun: Objective function values in each decomposition level
%   an_x: X axis of the maximum objective function value in each
%   decomposition level
%   an_y: Y axis of the maximum objective function value in each
%   decomposition level
%   ObjFun_an: the maximum objective function value in each decomposition
%   level
%   reduced_reminder: reduced reminder in each decomposition level
%   standard_reminder: standard reminder in each decomposition level
%
if length(varargin)>1
    disp('Error: too many inputs.')
    return;
elseif isempty(varargin)
    L=0:2*pi/length(s):(2*pi-2*pi/length(s));
elseif length(varargin)==1
    L=varargin{1};
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert the signal to its discrete time format
K=length(s);
t=0:2*pi/K:(2*pi-2*pi/K);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert the signal s to its analytic representation
if isreal(s)
    G=hilbert(s);
else
    G=s;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate a_n dictionary
if size(M)==[1 1]
    abs_a=linspace(0,1,M+1);
    abs_a=abs_a(1:end-1);
else
    if find(size(M)==1)==1
        abs_a=M;
    elseif find(size(M)==1)==2
        abs_a=M.';
    else
        disp('Error: the size of M is not correct.');
        return;
    end
end
if size(L)==[1 1]
    phase_a=linspace(0,2*pi,L+1);
    phase_a=phase_a(1:end-1);
else
    if find(size(L)==1)==1
        phase_a=L;
    elseif find(size(L)==1)==2
        phase_a=L.';
    else
        disp('Error: the size of L is not correct.');
        return;
    end
end
dic_an=abs_a;
G_temp=zeros(1,length(phase_a));
for k=1:length(phase_a)
    [~,I]=min(abs(t-phase_a(k)));
    G_temp(k)=G(I);
    phase_a(k)=t(I);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate evaluator
Base=zeros(length(abs_a),length(phase_a));
for k=1:size(Base,1)
    Base(k,:)=fft(e_a(dic_an(k),exp(1j.*phase_a)),length(phase_a));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate weight for the numerical integration
Weight=ones(K,1);%weight(length(phase_a),6);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[XX,YY]=meshgrid(abs_a,phase_a);
XX=XX.';YY=YY.';
% Initilization
an=zeros(1,max_level+1);
coef=zeros(1,max_level+1);
coef(1)=intg(G_temp,ones(size(phase_a)),Weight);
an_x{1}=0;
an_y{1}=0;
ObjFun_an{1}=coef(1);
reduced_reminder{1}=G_temp;
standard_reminder{1}=G_temp;
B_n(1,:)=(sqrt(1-abs(an(1))^2)./(1-conj(an(1))*exp(t.*1i)));
% Main decomposition loop
for n=2:(max_level+1)
    F_n(n-1,:)=coef(n-1).*B_n(n-1,:);
    standard_reminder{n}=standard_reminder{n-1}-F_n(n-1,:);
    e_an=e_a(an(n-1),exp(1j.*phase_a));
    G_temp=(G_temp-coef(n-1).*e_an).*(1-conj(an(n-1)).*exp(1j.*phase_a))./(exp(1j.*phase_a)-an(n-1));
    S1=ifft(repmat(fft(G_temp.*Weight.',length(phase_a)),size(Base,1),1).*Base,length(phase_a),2);
    ObjFun{n}=S1;
    [S2,I1]=max(abs(S1));
    [~,I2]=max(S2);
    an(n)=dic_an(I1(I2)).*exp(1j.*phase_a(I2));
    an_x{n}=abs(an(n));
    an_y{n}=phase_a(I2);
    ObjFun_an{n}=S1(I1(I2),I2);
    reduced_reminder{n}=G_temp;
    coef(n)=conj(e_a(an(n),exp(t.*1i))*(reduced_reminder{n}'.*Weight))./length(t);
    B_n(n,:)=(sqrt(1-abs(an(n))^2)./(1-conj(an(n))*exp(t.*1i))).*((exp(1i*t)-an(n-1))./(sqrt(1-abs(an(n-1))^2))).*B_n(n-1,:);
end

end