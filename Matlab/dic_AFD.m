function dic_n=dic_AFD(an,t)
% Obtain the dictionary components at the certain an
%
% dic_n=dic_AFD(an,t)
%
% Input:
%   an: a_n array for n=0,1,2,...,N
%   t: time sample points of the discrete time signal
%
% Output:
%   dic_n: dictionary components
dic_n=zeros(length(an),length(t));
for n=1:length(an)
    dic_n(n,:)=e_a(an(n),exp(1j.*t));
end

end