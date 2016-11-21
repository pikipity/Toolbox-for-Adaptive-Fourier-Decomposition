function [an,coef,t]=conv_AFD(s,max_level,M,L)
% AFD based on the conventional exhaustive basis searching
%
% [an,coef,t]=conv_AFD(s,max_level,M,L)
%
% Inputs:
%   s: pocessed discrete signal
%   max_level: maximum decomposition level
%   M: if it is a integer number, it is the maximum number of the magnitude
%      values of a_n in the searching dictionary, and the dictionary of the
%      magnitude values is unique distributed in [0,1).
%      if it is an array, it is the dictionary of the magnitude values.
%   L: if it is a integer number, it is the maximum number of the phase
%      values of a_n in the searching dictionary, and the dictionary of the
%      phase values is unique distributed in [0,2*pi).
% Outputs:
%   an: values of a_n for n=0,2,...,N
%   coef: values of coef_n for n=0,2,...,N
%
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
dic_an=zeros(length(abs_a),length(phase_a));
for m=1:length(abs_a)
    for l=1:length(phase_a)
        dic_an(m,l,:)=abs_a(m).*exp(1j.*phase_a(l));
    end
end
dic_an=reshape(dic_an,1,length(abs_a)*length(phase_a));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate evaluator
Base=zeros(length(abs_a)*length(phase_a),K);
for k=1:size(Base,1)
    Base(k,:)=e_a(dic_an(k),exp(1j.*t));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate weight for the numerical integration
Weight=weight(K,6);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initilization
an=zeros(1,max_level+1);
coef=zeros(1,max_level+1);
coef(1)=intg(G,ones(size(t)),Weight);
for n=2:max_level
    e_an=e_a(an(n-1),exp(1j.*t));
    G=(G-coef(n-1).*e_an).*(1-conj(an(n-1)).*exp(1j.*t))./(exp(1j.*t)-an(n-1));
    S1=conj(Base*(G'.*Weight));
    [~,I]=max(abs(S1));
    coef(n)=S1(I);
    an(n)=dic_an(I);
end

end