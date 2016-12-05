function [G_recovery,n]=inverse_AFD(an,coef,t,varargin)
% Inverse AFD
%
% G_recovery=inverse_AFD(an,coef,t)
% G_recovery=inverse_AFD(an,coef,t,'level',max_level)
% G_recovery=inverse_AFD(an,coef,t,'energy',max_energy)
%
% Descriptions:
%   (1) G_recovery=inverse_AFD(an,coef,t): Build the reconstructed signal
%       G_reconvery using all an and coef.
%   (2) G_recovery=inverse_AFD(an,coef,t,'level',max_level): Build the
%       reconstructed signal G_recovery only using first max_level an and coef.
%   (3) G_recovery=inverse_AFD(an,coef,t,'energy',max_energy): Build the
%       reconstructed signal G_reconvery to make |G_reconvery| achieve the max_energy
%
% Inputs:
%   an: a_n array for n=0,1,2,...,N
%   coef: coeffient array for n=0,1,2,...,N
%   t: time sample points of the discrete time signal
%   max_level: max reconstructed level
%   max_energy: max reconstruction energy
%
% Output:
%   G_recovery: reconstructed analytic representation
%   n: reconstructed maximum level
if isempty(varargin)
    max_level=length(an)-1;
    max_energy=inf;
elseif length(varargin)==2
    switch lower(varargin{1})
        case 'level'
            max_level=varargin{2};
            max_energy=inf;
        case 'energy'
            max_level=length(an)-1;
            max_energy=varargin{2};
        otherwise
            disp('Error: the limit condition must be level or energy')
            return;
    end
else
    disp('Error: wrong inputs')
    return;
end

Weight=weight(length(t),6);
tem_B=(sqrt(1-abs(an(1))^2)./(1-conj(an(1))*exp(t.*1i)));
G_recovery=coef(1).*tem_B;
n=1;
energy=intg(real(G_recovery),real(G_recovery),Weight);
while n<(max_level+1) && energy<max_energy && n<length(an)
    n=n+1;
    tem_B=(sqrt(1-abs(an(n))^2)./(1-conj(an(n))*exp(t.*1i))).*((exp(1i*t)-an(n-1))./(sqrt(1-abs(an(n-1))^2))).*tem_B;
    G_recovery=G_recovery+coef(n).*tem_B;
    energy=intg(real(G_recovery),real(G_recovery),Weight);
end

end