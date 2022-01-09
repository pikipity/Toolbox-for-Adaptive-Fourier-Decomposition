function plot_ori_sig(obj)
    figure('name','Original Signal')
    K=size(obj.G,1);
    for ch_i=1:K
        subplot(K,1,ch_i)
        obj.plot_sig({obj.t(ch_i,:)},{real(obj.G(ch_i,:))},...
                     'phase',['channel ' num2str(ch_i)]);
    end
end