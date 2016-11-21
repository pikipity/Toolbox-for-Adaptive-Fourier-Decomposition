function [ ret ] = e_a(a,z)
%
%input: 'a' is a point in the unit disk;
%       'z' is a complex variable.
ret=((1-abs(a).^2).^(0.5))./(1-conj(a).*z);


end

