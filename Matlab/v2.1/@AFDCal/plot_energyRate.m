function plot_energyRate(obj,level)
    if level>obj.level
        error('Level is too large')
    end
    if level<1
        error('Level is too small')
    end

    N=level;
    energyRate = zeros(size(obj.G,1),N+1);
    for ch_i=1:size(obj.G,1)
        for n=1:N+1
            if n==1
                tmp = real(obj.G(ch_i,:))-real(obj.deComp{ch_i,1}(1,:));
            else
                reSig = obj.cal_reSig(n-1);
                tmp = real(obj.G(ch_i,:))-real(reSig(ch_i,:));
            end
            energyRate(ch_i,n) = obj.intg(tmp,tmp,obj.Weight);
        end
        energyRate(ch_i,:) = energyRate(ch_i,:)./energyRate(ch_i,1);
    end
    
    figure('name',['Energy Rate of first ' num2str(level) ' levels'])
    for ch_i=1:size(obj.G,1)
        subplot(size(obj.G,1),1,ch_i)
        plot(0:level,energyRate(ch_i,:),'x-') 
        grid on
        xlabel('Decomposition Level')
        ylabel('Reminder Energy Ratio')
    end
end