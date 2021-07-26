function ret = blaschke1(r,t)
    x = exp(1i*t);
    B = ones(size(t));
    if(isempty(r))
    else
        a1 = r(abs(r)~=0);
        for k = 1:length(a1)
            B = B.*(x-a1(k))./(1-conj(a1(k))*x).*(-conj(a1(k))/abs(a1(k)));
        end
        n = length(r)-length(a1);
        B = B.*x.^n;
    end
    ret=B;
end