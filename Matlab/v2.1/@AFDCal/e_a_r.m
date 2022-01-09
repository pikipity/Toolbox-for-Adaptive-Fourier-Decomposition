function ret = e_a_r(a,z)
%
%input: 'a' is a point in the unit disk;
%       'z' is a complex variable.

ret=1./(1-conj(a).*z);
% 1./(1-conj(C(k)).*x);

end

