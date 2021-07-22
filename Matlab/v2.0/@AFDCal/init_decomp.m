function init_decomp(obj,varargin)

    if isempty(obj.s)
        obj.addLog('warning: Because there is not input signal, the decomposition cannot be initilized.')
        warning('Because there is not input signal, the decomposition cannot be initilized.')
        return
    end
    
    if length(varargin)<1
        searching_an_flag = 1;
    else
        searching_an_flag = varargin{1};
    end

    obj.level = 0;
    K=size(obj.G,1);
    obj.remainder = obj.G;
    for ch_i=1:K
        tic
        if searching_an_flag
            % S1
            obj.S1{ch_i,obj.level+1}=[];
            obj.max_loc{ch_i,obj.level+1}=[];
            % an
            obj.an{ch_i,1}=[];
            an=0;
            obj.an{ch_i,1}=[obj.an{ch_i,1} an];
            % coef
            obj.coef{ch_i,1}=[];
            coef=conj(obj.e_a(an,exp(obj.t(ch_i,:).*1i))*(obj.remainder(ch_i,:)'.*obj.Weight))./length(obj.t(ch_i,:));%obj.intg(obj.G(ch_i,:),ones(size(obj.t(ch_i,:))),obj.Weight);
            obj.coef{ch_i,1}=[obj.coef{ch_i,1} coef];
        else
            % S1
            obj.S1{ch_i,obj.level+1}=[];
            obj.max_loc{ch_i,obj.level+1}=[];
            % an
            an=obj.an{ch_i,1}(obj.level+1);
            % coef
            coef=obj.coef{ch_i,1}(obj.level+1);
        end
        % tem_B
        obj.tem_B{ch_i,1}=[];
        tem_B = (sqrt(1-abs(an)^2)./(1-conj(an)*exp(obj.t(ch_i,:).*1i)));
        obj.tem_B{ch_i,1}=[obj.tem_B{ch_i,1};...
                           tem_B];
        % deComp
        obj.deComp{ch_i,1}=[];
        deComp = coef.*tem_B;
        obj.deComp{ch_i,1}=[obj.deComp{ch_i,1};...
                            deComp];
        % remainder
        e_an=obj.e_a(an,exp(1j.*obj.t(ch_i,:)));
        obj.remainder(ch_i,:) =(obj.remainder(ch_i,:)-coef.*e_an).*(1-conj(an).*exp(1j.*obj.t(ch_i,:)))./(exp(1j.*obj.t(ch_i,:))-an);
        % time
        obj.run_time(ch_i,1)=toc;
    end
    
    obj.addLog('The decomposition has been initilized.')
end