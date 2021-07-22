function plot_evaluator(obj)
    K=size(obj.G,1);
    for ch_i=1:K
        figure('name',['Magnitude of Evaluators, Ch ' num2str(ch_i)])
        Base=obj.Base{ch_i,1};
        a=obj.dic_an{ch_i,1};
        N=size(Base,1);
        M=size(Base,2);
        %
        if N>1
            m=floor(M/2);
            subplot(1,2,1)
            hold on
            legend_label={};
            ind=unique(floor(linspace(1,N,5)));
            plot_t={};
            plot_s={};
            for k=1:length(ind)
                plot_t{1,k}=obj.t(ch_i,:);
                plot_s{1,k}=abs(squeeze(Base(ind(k),m,:)));
                legend_label{1,k}=['a=' num2str(a(ind(k),m))];
            end
            obj.plot_sig(plot_t,...
                         plot_s,...
                         'phase','');
            legend(legend_label)
        end
        %
        if N>1
            k=floor(N/2);
        else
            k=1;
        end
        subplot(1,2,2)
        hold on
        legend_label={};
        ind=unique(floor(linspace(1,M,5)));
        plot_t={};
        plot_s={};
        for m=1:length(ind)
            plot_t{1,m}=obj.t(ch_i,:);
            plot_s{1,m}=abs(squeeze(Base(k,ind(m),:)));
            legend_label{1,m}=['a=' num2str(a(k,ind(m)))];
        end
        obj.plot_sig(plot_t,...
                     plot_s,...
                     'phase','');
        legend(legend_label)
    end
    K=size(obj.G,1);
    for ch_i=1:K
        figure('name',['Phase of Evaluators, Ch ' num2str(ch_i)])
        Base=obj.Base{ch_i,1};
        a=obj.dic_an{ch_i,1};
        N=size(Base,1);
        M=size(Base,2);
        %
        if N>1
            m=floor(M/2);
            subplot(1,2,1)
            hold on
            legend_label={};
            ind=unique(floor(linspace(1,N,5)));
            plot_t={};
            plot_s={};
            for k=1:length(ind)
                plot_t{1,k}=obj.t(ch_i,:);
                plot_s{1,k}=phase(squeeze(Base(ind(k),m,:)));
                legend_label{1,k}=['a=' num2str(a(ind(k),m))];
            end
            obj.plot_sig(plot_t,...
                         plot_s,...
                         'phase','');
            legend(legend_label)
        end
        %
        if N>1
            k=floor(N/2);
        else
            k=1;
        end
        subplot(1,2,2)
        hold on
        legend_label={};
        ind=unique(floor(linspace(1,M,5)));
        plot_t={};
        plot_s={};
        for m=1:length(ind)
            plot_t{1,m}=obj.t(ch_i,:);
            plot_s{1,m}=phase(squeeze(Base(k,ind(m),:)));
            legend_label{1,m}=['a=' num2str(a(k,ind(m)))];
        end
        obj.plot_sig(plot_t,...
                     plot_s,...
                     'phase','');
        legend(legend_label)
    end
%     K=size(obj.G,1);
%     % adjust index
%     for ch_i=1:K
%         ind=allInd{ch_i};
%         if length(ind)>size(obj.Base{ch_i,1},1)
%             ind = 1:size(obj.Base{ch_i,1},1);
%         end
%         ind=ind(ind>0);
%         ind=unique(floor(ind));
%         if length(ind)<=0
%             ind = 1:size(obj.Base{ch_i,1},1);
%         elseif length(ind)>5
%             ind=ind(1:5);
%         end
%         allInd{ch_i}=ind;
%     end
%     row_num=max(cellfun(@(x) length(x),allInd(1:K)));
%     for ch_i=1:K
%         ind=allInd{ch_i};
%         for i=1:length(ind)
%             subplot(row_num,K,(i-1)*2+ch_i)
%             obj.plot_sig({obj.t(ch_i,:),obj.t(ch_i,:)},...
%                          {abs(obj.Base{ch_i,1}(ind(i),:))-1,phase(obj.Base{ch_i,1}(ind(i),:))},...
%                          'phase','');
%             title(['Ch ' num2str(ch_i) ', Ind ' num2str(ind(i)) ', a=' num2str(obj.dic_an{ch_i,1}(ind(i)))])
%         end
%     end
end