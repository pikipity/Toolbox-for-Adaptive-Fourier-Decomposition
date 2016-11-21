function y=weight(n,Order,varargin)
%
%Compute the integral by Newton-Cotes method
%
  y=zeros(n,1);
  if nargin==1
      Order=3;              % Here we use the 3 Order
  end
                                % Newton-Cotes method
Newton=zeros(Order+1,Order);    % This matrix contains the coefficients of
				% Newton-Cotes method of order 2 to Order.
Newton(1:2,1)=[1/2;1/2];
Newton(1:3,2)=[1/6;4/6;1/6];
Newton(1:4,3)=[1/8;3/8;3/8;1/8];
Newton(1:5,4)=[7/90;16/45;2/15;16/45;7/90];
Newton(1:6,5)=[19/288;25/96;25/144;25/144;25/96;19/288];
Newton(1:7,6)=[41/840;9/35;9/280;34/105;9/280;9/35;41/840];

k=floor((n-1)/Order);
if k>0
  for iter=1:k
    y((iter*Order-Order+1):(iter*Order+1))=...
	y((iter*Order-Order+1):(iter*Order+1))...
	+nonzeros(Newton(:,Order));
  end
end
y=y*Order/(n-1);
nleft=n-k*Order-1;
    
% for the left NLEFT points, use the corresponding
% Newton-Cotes method.
if nleft>0
  y((n-nleft):n)=...
      y((n-nleft):n)+nonzeros(Newton(:,nleft))*nleft/(n-1);
end