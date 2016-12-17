function F_n=Fn_AFD(an,coef,t)
% Obtain decomposition components (B_n with coefficients)
%
% F_n=Fn_AFD(an,coef,t)
%
% Input:
%   an: a_n array for n=0,1,2,...,N
%   coef: coeffient array for n=0,1,2,...,N
%   t: time sample points of the discrete time signal
%
% Output:
%   F_n: decomposition components
F_n=zeros(length(an),length(t));
B_n=Bn_AFD(an,t);
for n=1:length(an)
    F_n(n,:)=coef(n).*B_n(n,:);
end

end