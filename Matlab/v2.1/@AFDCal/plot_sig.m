function plot_sig(t,s,xlab,ylab)
    for k=1:length(t)
        plot(t{k},s{k},'linewidth',2)
        hold on
    end
    grid on
    cellmin=@(C) cellfun(@(x) min(x),C);
    cellmax=@(C) cellfun(@(x) max(x),C);
    min_t=min(cellmin(t));
    max_t=max(cellmax(t));
    if min_t==max_t
        max_t=max_t+0.001;
    end
    min_s=min(cellmin(s));
    max_s=max(cellmax(s));
    if min_s==max_s
        max_s=max_s+0.001;
    end
    axis([min_t max_t min_s max_s])
    xlabel(xlab)
    ylabel(ylab)
end