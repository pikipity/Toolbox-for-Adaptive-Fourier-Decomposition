function ret = Unit_Disk(dist,cont)
    t=-1:dist:1;
    [~,n] = size(t);
    real = repmat(t,n,1);
    image = repmat(t',1,n);
    ret1 = real + 1j.*image;
    ret1(abs(ret1) >= cont) = nan;
    ret = ret1;
    %
    remove_row=[];
    for i=1:size(ret,1)
        if sum(isnan(ret(i,:)))==size(ret,2)
            remove_row=[remove_row i];
        end
    end
    ret(remove_row,:)=[];
    remove_col=[];
    for j=1:size(ret,2)
        if sum(isnan(ret(:,j)))==size(ret,1)
            remove_col=[remove_col j];
        end
    end
    ret(:,remove_col)=[];
%     real = repmat(t',n,1);
%     image = repmat(t',1,n);
%     image = reshape(image',n^2,1);
%     ret1 = real + 1j.*image;
%     ret2 = ret1.*(abs(ret1) < cont);
%     ret2 = ret2(abs(ret2) > 0);
%     ret2 = sort(ret2);
%     ret = [ret2;0];
end