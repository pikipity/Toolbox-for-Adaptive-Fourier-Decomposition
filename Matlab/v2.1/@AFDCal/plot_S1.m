function plot_S1(obj,level)
    if level>obj.level
        error('Level is too large')
    end
    if level<1
        error('Level is too small')
    end
    figure('name',['Energy Distribution at level ' num2str(level)])
    
    K=size(obj.G,1);
    for ch_i=1:K
        subplot(1,K,ch_i)
        S1 = obj.S1{ch_i,level+1};
        max_loc = obj.max_loc{ch_i,level+1};
        switch obj.decompMethod
           case 'Single Channel Conventional AFD'
               XX = real(obj.dic_an{ch_i,1});
               YY = imag(obj.dic_an{ch_i,1});
           case 'Single Channel Fast AFD'
               [XX,YY]=meshgrid(obj.t(ch_i,:),obj.dic_an{ch_i,1});
        end
        ZZ = abs(S1);
        try
            mesh(XX,YY,ZZ)
            hold on
            plot3(XX(max_loc(1),max_loc(2)),...
                  YY(max_loc(1),max_loc(2)),...
                  ZZ(max_loc(1),max_loc(2)),...
                  'rx')
        catch
            X=reshape(XX,1,numel(XX));
            XX=unique(X);
            Y=reshape(YY,1,numel(YY));
            YY=unique(Y);
            Z=ZZ;
            [XX,YY]=meshgrid(XX,YY);
            ZZ=zeros(size(XX));
            for i=1:length(X)
                    [~,ind_2]=find(XX==X(i));
                    ind_2=ind_2(1);
                    [ind_1,~]=find(YY==Y(i));
                    ind_1=ind_1(1);
                    ZZ(ind_1,ind_2)=Z(i);
            end
            mesh(XX,YY,ZZ)
            ind_tmp=find(size(max_loc)~=1);
            [~,ind_2]=find(XX==X(max_loc(ind_tmp)));
            ind_2=ind_2(1);
            [ind_1,~]=find(YY==Y(max_loc(ind_tmp)));
            ind_1=ind_1(1);
            hold on
            plot3(XX(ind_1,ind_2),...
                  YY(ind_1,ind_2),...
                  ZZ(ind_1,ind_2),...
                  'rx')
        end
        switch obj.decompMethod
           case 'Single Channel Conventional AFD'
               xlabel('Real')
               ylabel('Imag')
           case 'Single Channel Fast AFD'
               xlabel('Phase')
               ylabel('Magnitude')
        end
        zlabel('S1')
    end
end