function ret = Circle_Disk(dist,cont,phase)
    abs_a=0:dist:1;
    abs_a=abs_a(1:end-1);
    phase_a=phase;
    
    tmp=[];
    for m=1:length(abs_a)
        for l=1:length(phase_a)
            tmp(m,l,:)=abs_a(m).*exp(1j.*phase_a(l));
        end
    end
    ret1=tmp;
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
%     ret1=reshape(tmp,1,length(abs_a)*length(phase_a)).';
%     ret2 = ret1.*(abs(ret1) < cont);
%     ret2 = ret2(abs(ret2) > 0);
%     ret2 = sort(ret2);
%     ret = [ret2;0];
end