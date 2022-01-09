function plot_basis(obj,level)
    if level>obj.level
        error('Level is too large')
    end
    if level<1
        error('Level is too small')
    end
    
    figure('name',['Decomposition Basis at level ' num2str(level)])
    
    K=size(obj.G,1);
    for ch_i=1:K
        subplot(K,1,ch_i)
        hold on
        obj.plot_sig({obj.t(ch_i,:),obj.t(ch_i,:),obj.t(ch_i,:)},...
                     {real(obj.G(ch_i,:)),real(obj.tem_B{ch_i,1}(level+1,:)),imag(obj.tem_B{ch_i,1}(level+1,:))},...
                     'phase','');        
        legend({'Original Signal',...
            'Real Basis',...
            'Imag Basis'})
    end
end