function genEva(obj)
    obj.time_genEva=zeros(size(obj.G,1),1);
    if ~isempty(strfind(obj.decompMethod,'Conventional AFD'))
        % evaluator for an
        for ch_i=1:size(obj.G,1)
            tic
            if ~isempty(strfind(obj.decompMethod,'Single Channel'))
                dic_tmp=obj.dic_an{ch_i,1};
            elseif ~isempty(strfind(obj.decompMethod,'Multi-channel'))
                dic_tmp=obj.dic_an{1,1};
            end
            t_tmp=obj.t(ch_i,:);
            obj.Base{ch_i,1}=zeros(size(dic_tmp,1),size(dic_tmp,2),length(t_tmp));
            for i=1:size(dic_tmp,1)
                for j=1:size(dic_tmp,2)
                    obj.Base{ch_i,1}(i,j,:)=obj.e_a(dic_tmp(i,j),exp(1j.*t_tmp));
                end
            end
            obj.time_genEva(ch_i,1)=toc;
        end
        % evaluator for r
        switch obj.AFDMethod
            case 'unwinding'
                for ch_i=1:size(obj.G,1)
                    tic
                    if ~isempty(strfind(obj.decompMethod,'Single Channel'))
                        dic_tmp=obj.dic_an{ch_i,1};
                    elseif ~isempty(strfind(obj.decompMethod,'Multi-channel'))
                         dic_tmp=obj.dic_an{1,1};
                    end
                    t_tmp=obj.t(ch_i,:);
                    obj.Base_r{ch_i,1}=zeros(size(dic_tmp,1),size(dic_tmp,2),length(t_tmp));
                    for i=1:size(dic_tmp,1)
                        for j=1:size(dic_tmp,2)
                            obj.Base_r{ch_i,1}(i,j,:)= obj.e_a_r(dic_tmp(i,j),exp(1j.*t_tmp));
                        end
                    end
                    obj.time_genEva(ch_i,1)=obj.time_genEva(ch_i,1)+toc;
                end
        end
    elseif ~isempty(strfind(obj.decompMethod,'Fast AFD'))
        % evaluator for an
        for ch_i=1:size(obj.G,1)
            tic
            if ~isempty(strfind(obj.decompMethod,'Single Channel'))
                dic_tmp=obj.dic_an{ch_i,1};
            elseif ~isempty(strfind(obj.decompMethod,'Multi-channel'))
                dic_tmp=obj.dic_an{1,1};
            end
            t_tmp=obj.t(ch_i,:);
            obj.Base{ch_i,1}=zeros(1,length(dic_tmp),length(t_tmp));
            for k=1:length(dic_tmp)
                obj.Base{ch_i,1}(1,k,:)=fft(obj.e_a(dic_tmp(k),exp(1j.*t_tmp)),length(t_tmp));
            end
            obj.time_genEva(ch_i,1)=toc;
        end
         % evaluator for r
         switch obj.AFDMethod
             case 'unwinding'
                 for ch_i=1:size(obj.G,1)
                     tic
                     if ~isempty(strfind(obj.decompMethod,'Single Channel'))
                        dic_tmp=obj.dic_an{ch_i,1};
                     elseif ~isempty(strfind(obj.decompMethod,'Multi-channel'))
                        dic_tmp=obj.dic_an{1,1};
                     end
                     t_tmp=obj.t(ch_i,:);
                     obj.Base_r{ch_i,1}=zeros(1,length(dic_tmp),length(t_tmp));
                     for k=1:length(dic_tmp)
                         obj.Base_r{ch_i,1}(1,k,:)=fft(obj.e_a_r(dic_tmp(k),exp(1j.*t_tmp)),length(t_tmp));
                     end
                     obj.time_genEva(ch_i,1)=obj.time_genEva(ch_i,1)+toc;
                 end
         end
    end
    
    obj.addLog('generate evaluators successfully.')
end