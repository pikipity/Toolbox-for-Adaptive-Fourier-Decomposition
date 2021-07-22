function genEva(obj)
    obj.time_genEva=zeros(size(obj.G,1),1);
    switch obj.decompMethod
        case 'Single Channel Conventional AFD'
            for ch_i=1:size(obj.G,1)
                tic
                dic_tmp=obj.dic_an{ch_i,1};
                t_tmp=obj.t(ch_i,:);
                obj.Base{ch_i,1}=zeros(size(dic_tmp,1),size(dic_tmp,2),length(t_tmp));
                for i=1:size(dic_tmp,1)
                    for j=1:size(dic_tmp,2)
                        obj.Base{ch_i,1}(i,j,:)=obj.e_a(dic_tmp(i,j),exp(1j.*t_tmp));
                    end
                end
                obj.time_genEva(ch_i,1)=toc;
            end
        case 'Single Channel Fast AFD'
            for ch_i=1:size(obj.G,1)
                tic
                dic_tmp=obj.dic_an{ch_i,1};
                t_tmp=obj.t(ch_i,:);
                obj.Base{ch_i,1}=zeros(1,length(dic_tmp),length(t_tmp));
                for k=1:length(dic_tmp)
                    obj.Base{ch_i,1}(1,k,:)=fft(obj.e_a(dic_tmp(k),exp(1j.*t_tmp)),length(t_tmp));
                end
                obj.time_genEva(ch_i,1)=toc;
            end
    end

    obj.addLog('generate evaluators successfully.')
end