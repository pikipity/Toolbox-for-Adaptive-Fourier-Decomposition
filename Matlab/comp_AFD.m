function [dic_n,B_n,F_n]=comp_AFD(an,coef,t)
% Obtain the dictionary components at the certain an, basis B_n
% (Non-coefficients), decomposition components (B_n with coefficients)
%
% [dic_n,B_n,F_n]=comp_AFD(an,coef,t)
%
% Input:
%   an: a_n array for n=0,1,2,...,N
%   coef: coeffient array for n=0,1,2,...,N
%   t: time sample points of the discrete time signal
%
% Output:
%   dic_n: dictionary components e_an
%   B_n: basis B_n
%   F_n: decomposition components F_n
dic_n=zeros(length(an),length(t));
B_n=zeros(length(an),length(t));
F_n=zeros(length(an),length(t));
B_n(1,:)=(sqrt(1-abs(an(1))^2)./(1-conj(an(1))*exp(t.*1i)));
F_n(1,:)=coef(1).*B_n(1,:);
for n=1:length(an)
    dic_n(n,:)=e_a(an(n),exp(1j.*t));
    if n>1
        B_n(n,:)=(sqrt(1-abs(an(n))^2)./(1-conj(an(n))*exp(t.*1i))).*((exp(1i*t)-an(n-1))./(sqrt(1-abs(an(n-1))^2))).*B_n(n-1,:);
        F_n(n,:)=coef(n).*B_n(n,:);
    end
end

end