function plot_dic(obj)
    figure('name','Searching Dictionary')
    K=size(obj.G,1);
    for ch_i=1:K
        if K<=5
            subplot(1,K,ch_i)
        else
            subplot(ceil(K/5),5,ch_i)
        end
        obj.plot_point(real(obj.dic_an{ch_i,1}),imag(obj.dic_an{ch_i,1}),...
                       'Real','Imag')
        axis([-1 1 -1 1])
        title(['Channel ' num2str(ch_i)])
    end
end