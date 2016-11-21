function G_recovery=inverse_AFD(an,coef,t)
% Inverse AFD
% G_recovery=inverse_AFD(an,coef)
%
% Inputs:
%   an: a_n array for n=0,1,2,...,N
%   coef: coeffient array for n=0,1,2,...,N
%   t: time sample points of the discrete time signal
% Output:
%   G_recovery: reconstructed analytic representation
tem_B=(sqrt(1-abs(an(1))^2)./(1-conj(an(1))*exp(t.*1i)));
G_recovery=coef(1).*tem_B;
for n=2:length(an)
    tem_B=(sqrt(1-abs(an(n))^2)./(1-conj(an(n))*exp(t.*1i))).*((exp(1i*t)-an(n-1))./(sqrt(1-abs(an(n-1))^2))).*tem_B;
    G_recovery=G_recovery+coef(n).*tem_B;
end
end