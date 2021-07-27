function set_dic_an(obj,dic_an)
    switch obj.decompMethod
        case 'Single Channel Fast AFD'
            obj.addLog('warning: Fast AFD is not allowed to set searching dictionary manually.')
            warning('Fast AFD is not allowed to set searching dictionary manually.')
            return
    end
    
    if ~isempty(strfind(obj.decompMethod,'Single Channel'))
        if size(dic_an,1)<size(obj.G,1)
            obj.addLog('warning: Because the specific searching dictionary is not correct, "set_dic_an" is not successful.')
            warning('Because the specific searching dictionary is not correct, "set_dic_an" is not successful.')
            return
        end
    elseif ~isempty(strfind(obj.decompMethod,'Multi-channel'))
        if size(dic_an,1)<1
            obj.addLog('warning: Because the specific searching dictionary is not correct, "set_dic_an" is not successful.')
            warning('Because the specific searching dictionary is not correct, "set_dic_an" is not successful.')
            return
        end
    end
    
    obj.setDicGenMethod(1);
    
    % remove redundent
    for ch_i=1:size(dic_an,1)
        dic_an{ch_i,1}=unique(dic_an{ch_i,1});
    end
    
    obj.dic_an=dic_an;
end