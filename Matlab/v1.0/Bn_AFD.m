function B_n=Bn_AFD(an,t)
% Obtain basis B_n (Non-coefficients)
%
% B_n=Bn_AFD(an,t)
%
% Input:
%   an: a_n array for n=0,1,2,...,N
%   t: time sample points of the discrete time signal
%
% Output:
%   B_n: Basis, one line for one level
B_n=zeros(length(an),length(t));
B_n(1,:)=(sqrt(1-abs(an(1))^2)./(1-conj(an(1))*exp(t.*1i)));
for n=2:length(an)
     B_n(n,:)=(sqrt(1-abs(an(n))^2)./(1-conj(an(n))*exp(t.*1i))).*((exp(1i*t)-an(n-1))./(sqrt(1-abs(an(n-1))^2))).*B_n(n-1,:);
end

end