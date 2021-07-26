function dispInfo(obj)
    % display information of computaiton model
    % dispInfo()
    obj.addLog(' ')
    obj.addLog('AFD Computation Module Information:')
    if isempty(obj.s)
        obj.addLog(['   Input signal is empty'])
        return
    end
    
    ch_num = size(obj.G,1);
    obj.addLog(['   Channel number (input signal): ' num2str(ch_num)])
    sig_len = size(obj.G,2);
    obj.addLog(['   Signal length (input signal): ' num2str(sig_len)])
    obj.addLog(['   Decomposition method: ' obj.decompMethod])
    obj.addLog(['   Dictionary generation method: ' obj.dicGenMethod])
    obj.addLog(['   Phase (2\pi): '])
    for ch_i=1:ch_num
        min_t = min(obj.t(ch_i,:))/(2*pi);
        max_t = max(obj.t(ch_i,:))/(2*pi);
        obj.addLog(['      channel ' num2str(ch_i) ': ' num2str(min_t) ' ~ ' num2str(max_t) '' ])
    end
    obj.addLog(['   Decomposition level: ' num2str(obj.level)])
    obj.addLog(['   dic_an: ' num2str(size(obj.dic_an,1)) ' * ' num2str(size(obj.dic_an,2))])
    if ~isempty(obj.dic_an)
        for ch_i=1:ch_num
            obj.addLog(['      channel ' num2str(ch_i) ': ' num2str(size(obj.dic_an{ch_i,1},1)) ' * ' num2str(size(obj.dic_an{ch_i,1},2)) ])
        end
    end
    obj.addLog(['   Base: ' num2str(size(obj.Base,1)) ' * ' num2str(size(obj.Base,2))])
    if ~isempty(obj.Base)
        for ch_i=1:ch_num
            obj.addLog(['      channel ' num2str(ch_i) ': ' num2str(size(obj.Base{ch_i,1},1)) ' * ' num2str(size(obj.Base{ch_i,1},2)) ])
        end
    end
    obj.addLog(['   an: ' num2str(size(obj.an,1)) ' * ' num2str(size(obj.an,2))])
    if ~isempty(obj.an)
        for ch_i=1:ch_num
            obj.addLog(['      channel ' num2str(ch_i) ': ' num2str(size(obj.an{ch_i,1},1)) ' * ' num2str(size(obj.an{ch_i,1},2)) ])
        end
    end
    obj.addLog(['   coef: ' num2str(size(obj.coef,1)) ' * ' num2str(size(obj.coef,2))])
    if ~isempty(obj.coef)
        for ch_i=1:ch_num
            obj.addLog(['      channel ' num2str(ch_i) ': ' num2str(size(obj.coef{ch_i,1},1)) ' * ' num2str(size(obj.coef{ch_i,1},2)) ])
        end
    end
    obj.addLog(['   tem_B: ' num2str(size(obj.tem_B,1)) ' * ' num2str(size(obj.tem_B,2))])
    if ~isempty(obj.tem_B)
        for ch_i=1:ch_num
            obj.addLog(['      channel ' num2str(ch_i) ': ' num2str(size(obj.tem_B{ch_i,1},1)) ' * ' num2str(size(obj.tem_B{ch_i,1},2)) ])
        end
    end
    obj.addLog(['   deComp: ' num2str(size(obj.deComp,1)) ' * ' num2str(size(obj.deComp,2))])
    if ~isempty(obj.deComp)
        for ch_i=1:ch_num
            obj.addLog(['      channel ' num2str(ch_i) ': ' num2str(size(obj.deComp{ch_i,1},1)) ' * ' num2str(size(obj.deComp{ch_i,1},2)) ])
        end
    end
    
    obj.addLog(' ')
    
    obj.dispLog();
end