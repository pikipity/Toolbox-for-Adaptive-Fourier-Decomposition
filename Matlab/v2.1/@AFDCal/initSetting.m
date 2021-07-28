function initSetting(obj)
    % initialize computation setting
    % initSetting()
    if isempty(obj.s)
        obj.addLog('warning: Because there is not input signal, the computational settings are not initialized successfully.')
        warning('Because there is not input signal, the computational settings are not initialized successfully.')
        obj.G=[];
        obj.t=[];
        obj.Weight=[];
    else
        if isreal(obj.s)
            obj.G=hilbert(obj.s').';
        else
            obj.G=obj.s;
        end
        
        K=size(obj.G,2);
        ch_num=size(obj.G,1);
        obj.t=repmat(0:2*pi/K:(2*pi-2*pi/K),ch_num,1);
        obj.genWeight(1,K,0);
        %obj.Weight=ones(K,1);
    end
    
    obj.S1={};
    obj.max_loc={};
    obj.an={};
    obj.coef={};
    obj.level=0;
    obj.dic_an={};
    obj.Base={};
    obj.remainder=[];
    obj.tem_B={};
    obj.deComp={};
    obj.decompMethod = 'Single Channel Conventional AFD';
    obj.dicGenMethod = 'square';
    obj.AFDMethod = 'core';
    obj.run_time=[];
    obj.time_genDic=[];
    obj.time_genEva=[];
    
    obj.r_store={};
    obj.InProd={};
    obj.OutProd={};
    obj.Base_r={};
    obj.N_r=1e3;
    obj.tol_r=1e-3;
    
    obj.addLog('Initialize settings correctly')
end