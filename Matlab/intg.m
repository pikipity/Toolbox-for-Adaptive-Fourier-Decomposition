function [ ret ] = intg( f,g,Weigth)
%input:'f' is an array;
%      'g' is an array.

%Weigth=weight(length(f),6);
ret=f*(g'.*Weigth)./length(f);
end