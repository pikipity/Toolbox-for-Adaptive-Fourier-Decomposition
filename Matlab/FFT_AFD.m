function [an,coef,t]=FFT_AFD(s,max_level,M,varargin)
% AFD based on the FFT based basis searching
%
% [an,coef,t]=FFT_AFD(s,max_level,M)
% [an,coef,t]=FFT_AFD(s,max_level,M,L)
%
% Desciptions:
%   (1) [an,coef,t]=FFT_AFD(s,max_level,M): decomposes signal s to max_level
%       levels. The magnitude searching dictionary of an generated based on M.
%       The phase searching dictionary of an gnerated according to the length of
%       the signal s.
%   (2) [an,coef,t]=FFT_AFD(s,max_level,M,L): Same as (1) but the phase
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
%   an: values of a_n for n=0,2,...,N
%   coef: values of coef_n for n=0,2,...,N
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
Weight=weight(length(phase_a),6);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initilization
an=zeros(1,max_level+1);
coef=zeros(1,max_level+1);
coef(1)=intg(G_temp,ones(size(phase_a)),Weight);
% Main decomposition loop
for n=2:(max_level+1)
    e_an=e_a(an(n-1),exp(1j.*phase_a));
    G_temp=(G_temp-coef(n-1).*e_an).*(1-conj(an(n-1)).*exp(1j.*phase_a))./(exp(1j.*phase_a)-an(n-1));
    S1=ifft(repmat(fft(G_temp.*Weight.',length(phase_a)),size(Base,1),1).*Base,length(phase_a),2);
    [S2,I1]=max(abs(S1));
    [~,I2]=max(S2);
    an(n)=dic_an(I1(I2)).*exp(1j.*phase_a(I2));
    G=(G-coef(n-1).*e_a(an(n-1),exp(1j.*t))).*(1-conj(an(n-1)).*exp(1j.*t))./(exp(1j.*t)-an(n-1));
    coef(n)=conj(e_a(an(n),exp(t.*1i))*(G'.*weight(K,6)));
end

end