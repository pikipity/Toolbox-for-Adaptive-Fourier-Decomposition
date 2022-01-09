function genWeight(obj,method_no,n,newtonOrder)
    % generate weight for integration
    % genWeight(method_no,n,newtonOrder)
    % method_no: 1 -> all ones
    %            2 -> Newton-Cotes method
    % n: signal length
    % newtonOrder: order of Newton-Cotes method
    y = ones(n,1);
    if method_no == 2
        y = zeros(n,1);
        Newton = zeros(newtonOrder+1,newtonOrder); 
        Newton(1:2,1) = [1/2;1/2];
        Newton(1:3,2) = [1/6;4/6;1/6];
        Newton(1:4,3) = [1/8;3/8;3/8;1/8];
        Newton(1:5,4) = [7/90;16/45;2/15;16/45;7/90];
        Newton(1:6,5) = [19/288;25/96;25/144;25/144;25/96;19/288];
        Newton(1:7,6) = [41/840;9/35;9/280;34/105;9/280;9/35;41/840];

        k = floor((n-1)/newtonOrder);
        if k > 0
            iter = 1:1:k;
            nonNewton = nonzeros(Newton(:,newtonOrder));
            exNewton = repmat(nonNewton(1:end-1),k,1);
            exNewton = [exNewton;nonNewton(end)];
            exIter = iter*newtonOrder + 1;
            exNewton(exIter) = exNewton(exIter) + nonNewton(end);
            exNewton(end) = exNewton(end) - nonNewton(end);
            y(1:k*newtonOrder+1) = y(1:k*newtonOrder+1) + exNewton;
        end

        y = y*newtonOrder/(n-1);
        nleft = n-k*newtonOrder-1;

        if nleft > 0
            y((n-nleft):n) = y((n-nleft):n) + ...
                nonzeros(Newton(:,nleft))*nleft/(n-1);
        end
        
        y=y.*size(obj.t,2);
    end
    obj.Weight = y;
end