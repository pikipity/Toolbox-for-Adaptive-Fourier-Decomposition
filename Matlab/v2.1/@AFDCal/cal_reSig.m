function reSig = cal_reSig(obj,level)
    if level>obj.level
        error('Level is too large')
    end
    if level<1
        error('Level is too small')
    end
    
    reSig = zeros(size(obj.G));
    
    K=size(obj.G,1);
    for ch_i=1:K
        reSig(ch_i,:)=real(sum(obj.deComp{ch_i,1}(1:(level+1),:)));
    end
    
end