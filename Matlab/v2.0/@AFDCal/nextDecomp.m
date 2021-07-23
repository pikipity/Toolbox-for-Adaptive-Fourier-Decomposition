function nextDecomp(obj,varargin)
% nextDecomp() or nextDecomp(searching_an_flag)
% searching_an_flag: whether search an, default is true

    if isempty(obj.s)
        obj.addLog('warning: Because there is not input signal, the decomposition cannot be continued.')
        warning('Because there is not input signal, the decomposition cannot be continued.')
        return
    end
    
    if size(obj.dic_an,1)<size(obj.G,1) || ~isempty(find(cellfun(@(x) numel(x),obj.dic_an)==0))
        obj.addLog('warning: Because there is not searching dictionary, the decomposition cannot be continued. Please use "genDic" to generate searching dictionary.')
        warning('Because there is not searching dictionary, the decomposition cannot be continued. Please use "genDic" to generate searching dictionary.')
        return
    end
    
    if size(obj.Base,1)<size(obj.G,1) ||  ~isempty(find(cellfun(@(x) numel(x),obj.Base)==0))
        obj.addLog('warning: Because there is not evaluators, the decomposition cannot be continued. Please use "genEva" to generate evaluators.')
        warning('Because there is not evaluators, the decomposition cannot be continued. Please use "genEva" to generate evaluators.')
        return
    end
    
    switch obj.AFDMethod
        case 'unwinding'
            if size(obj.Base_r,1)<size(obj.G,1) ||  ~isempty(find(cellfun(@(x) numel(x),obj.Base_r)==0))
                obj.addLog('warning: Because there is not evaluators, the decomposition cannot be continued. Please use "genEva" to generate evaluators.')
                warning('Because there is not evaluators, the decomposition cannot be continued. Please use "genEva" to generate evaluators.')
                return
            end
    end
    
    switch obj.decompMethod
        case 'Single Channel Fast AFD'
            switch obj.dicGenMethod
                case 'square'
                    obj.addLog('warning: AFD only can use circle searching dictionary.')
                    warning('AFD only can use circle searching dictionary.')
                    return
            end
    end
    
    switch obj.decompMethod
        case 'Single Channel Fast AFD'
            if ~isempty(find(cellfun(@(x) size(x,1),obj.Base)~=1)) || ~isempty(find(cellfun(@(x) size(x,1),obj.dic_an)~=1))
                obj.addLog('warning: AFD only can use circle searching dictionary.')
                warning('AFD only can use circle searching dictionary.')
                return
            end
    end
    
    switch obj.AFDMethod
        case 'unwinding'
            switch obj.decompMethod
                case 'Single Channel Fast AFD'
                    if ~isempty(find(cellfun(@(x) size(x,1),obj.Base_r)~=1))
                        obj.addLog('warning: AFD only can use circle searching dictionary.')
                        warning('AFD only can use circle searching dictionary.')
                        return
                    end
            end
    end
    
    if length(varargin)<1
        searching_an_flag = 1;
    else
        searching_an_flag = varargin{1};
    end

    obj.level = obj.level + 1;
    K=size(obj.G,1);
    for ch_i=1:K
        tic
        if searching_an_flag
            % r
            switch obj.AFDMethod
                case 'unwinding'
                    obj.search_r(ch_i);
                    inprod = obj.blaschke1(obj.r_store{ch_i,obj.level+1},obj.t(ch_i,:));
                    obj.InProd{ch_i,1}=[obj.InProd{ch_i,1};...
                                       inprod];
                    obj.remainder(ch_i,:)=obj.remainder(ch_i,:)./inprod;
            end
            switch obj.decompMethod
                case 'Single Channel Conventional AFD'
                    % S1
                    obj.S1{ch_i,obj.level+1}=[];
                    for i=1:size(obj.Base{ch_i,1},1)
                        obj.S1{ch_i,obj.level+1}(i,:)=conj(squeeze(obj.Base{ch_i,1}(i,:,:))*(obj.remainder(ch_i,:)'.*obj.Weight));
                    end
                    [max_row_i,max_col_i]=find(obj.S1{ch_i,obj.level+1}==max(max(obj.S1{ch_i,obj.level+1})));
                    max_row_i=max_row_i(1);
                    max_col_i=max_col_i(1);
                    obj.max_loc{ch_i,obj.level+1}=[max_row_i,max_col_i];
                    % an
                    an=obj.dic_an{ch_i,1}(max_row_i,max_col_i);
                    obj.an{ch_i,1}=[obj.an{ch_i,1} an];
                    % coef
                    coef=conj(squeeze(obj.Base{ch_i,1}(max_row_i,max_col_i,:)).'*(obj.remainder(ch_i,:)'.*obj.Weight))./length(obj.t(ch_i,:));%conj(obj.e_a(an,exp(obj.t(ch_i,:).*1i))*(obj.remainder(ch_i,:)'.*obj.Weight))./length(obj.t(ch_i,:));
                    obj.coef{ch_i,1}=[obj.coef{ch_i,1} coef];
                case 'Single Channel Fast AFD'
                    % S1
                    phase_a=obj.t(ch_i,:);
                    Base=squeeze(obj.Base{ch_i,1}(1,:,:));
                    obj.S1{ch_i,obj.level+1}=ifft(repmat(fft(obj.remainder(ch_i,:).*obj.Weight.',length(phase_a)),size(Base,1),1).*Base,length(phase_a),2);
                    [max_row_i,max_col_i]=find(obj.S1{ch_i,obj.level+1}==max(max(obj.S1{ch_i,obj.level+1})));
                    max_row_i=max_row_i(1);
                    max_col_i=max_col_i(1);
                    obj.max_loc{ch_i,obj.level+1}=[max_row_i,max_col_i];
                    % an
                    an=obj.dic_an{ch_i,1}(max_row_i).*exp(1j.*phase_a(max_col_i));
                    obj.an{ch_i,1}=[obj.an{ch_i,1} an];
                    % coef
                    coef=conj(obj.e_a(an,exp(phase_a.*1i))*(obj.remainder(ch_i,:)'.*obj.Weight))./length(phase_a);
                    obj.coef{ch_i,1}=[obj.coef{ch_i,1} coef];
            end
        else
            % r
            switch obj.AFDMethod
                case 'unwinding'
                    inprod = obj.blaschke1(obj.r_store{ch_i,obj.level+1},obj.t(ch_i,:));
                    obj.InProd{ch_i,1}=[obj.InProd{ch_i,1};...
                                       inprod];
                    obj.remainder(ch_i,:)=obj.remainder(ch_i,:)./inprod;
            end
            % S1
            obj.S1{ch_i,obj.level+1}=[];
            obj.max_loc{ch_i,obj.level+1}=[];
            % an
            an=obj.an{ch_i,1}(obj.level+1);
            % coef
            coef=obj.coef{ch_i,1}(obj.level+1);
        end
        % tem_B
        tem_B = (sqrt(1-abs(an)^2)./(1-conj(an)*exp(obj.t(ch_i,:).*1i))).*((exp(1i*obj.t(ch_i,:))-obj.an{ch_i,1}(obj.level))./(sqrt(1-abs(obj.an{ch_i,1}(obj.level))^2))).*obj.tem_B{ch_i,1}(obj.level,:);
        switch obj.AFDMethod
            case 'unwinding'
                obj.OutProd{ch_i,1}=[obj.OutProd{ch_i,1};...
                                     tem_B];
                tem_B=tem_B.*inprod;
        end
        obj.tem_B{ch_i,1}=[obj.tem_B{ch_i,1};...
                           tem_B];
        % deComp
        deComp = coef.*tem_B;
        obj.deComp{ch_i,1}=[obj.deComp{ch_i,1};...
                            deComp];
        % remainder
        e_an=obj.e_a(an,exp(1j.*obj.t(ch_i,:)));
        obj.remainder(ch_i,:) =(obj.remainder(ch_i,:)-coef.*e_an).*(1-conj(an).*exp(1j.*obj.t(ch_i,:)))./(exp(1j.*obj.t(ch_i,:))-an);
        % time
        obj.run_time(ch_i,obj.level+1)=toc;
    end
    
    obj.addLog(['The decomposition at level ' num2str(obj.level) ' has been finished.'])
end