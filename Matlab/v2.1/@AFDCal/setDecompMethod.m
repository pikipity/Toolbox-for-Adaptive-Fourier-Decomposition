function setDecompMethod(obj,method_no)
    switch method_no
        case 1
            obj.decompMethod = 'Single Channel Conventional AFD';
        case 2
            obj.decompMethod = 'Single Channel Fast AFD';
            obj.addLog('Fast AFD only can use the "circle" dictionary. So the dicGenMethod is changed.')
            obj.setDicGenMethod(2)
        case 3
            obj.decompMethod = 'Multi-channel Conventional AFD';
        case 4
            K=size(obj.G,1);
            tmp=obj.t(1,:);
            for ch_i=1:K
                if sum(tmp==obj.t(ch_i,:))==length(obj.t(ch_i,:))
                    tmp=obj.t(ch_i,:);
                else
                    obj.addLog('warning: Multi-channel Fast AFD does not support different phases')
                    warning('Multi-channel Fast AFD does not support different phases.')
                    return
                end
            end
            obj.decompMethod = 'Multi-channel Fast AFD';
            obj.addLog('Fast AFD only can use the "circle" dictionary. So the dicGenMethod is changed.')
            obj.setDicGenMethod(2)
        otherwise
            obj.addLog('error: Because the specific decompMethod is unknown, setDecompMethod is not successful.')
            error('Because the specific decompMethod is unknown, setDecompMethod is not successful.')
    end
    
    obj.addLog('setDecompMethod is successful.')
end