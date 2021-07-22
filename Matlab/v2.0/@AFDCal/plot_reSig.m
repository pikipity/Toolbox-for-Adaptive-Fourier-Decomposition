function plot_reSig(obj,level)
    if level>obj.level
        error('Level is too large')
    end
    if level<1
        error('Level is too small')
    end
    
    figure('name',['Reconstructed Signal of first ' num2str(level) ' levels'])
    
    K=size(obj.G,1);
    for ch_i=1:K
        subplot(K,1,ch_i)
        hold on
        obj.plot_sig({obj.t(ch_i,:),obj.t(ch_i,:)},...
                     {real(obj.G(ch_i,:)),real(sum(obj.deComp{ch_i,1}(1:(level+1),:)))},...
                     'phase','');   
        legend({'Original Signal',...
            'Reconstructed Signal'})
    end
    
end