function plot_point(t,s,xlab,ylab)
    plot(t,s,'x')
    grid on
    min_t=min(min(t));
    max_t=max(max(t));
    if min_t==max_t
        max_t=max_t+0.001;
    end
    min_s=min(min(s));
    max_s=max(max(s));
    if min_s==max_s
        max_s=max_s+0.001;
    end
    axis([min_t max_t min_s max_s])
    xlabel(xlab)
    ylabel(ylab)
end