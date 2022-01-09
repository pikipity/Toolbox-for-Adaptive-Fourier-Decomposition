function set_an(obj,an)
    if ~isempty(strfind(obj.decompMethod,'Single Channel'))
        if size(an,1)<size(obj.G,1)
            obj.addLog('warning: Because the specific a_n arrray is not correct, "set_an" is not successful.')
            warning('Because the specific a_n arrray is not correct, "set_an" is not successful.')
            return
        end
    elseif ~isempty(strfind(obj.decompMethod,'Multi-channel'))
        if size(an,1)<1
            obj.addLog('warning: Because the specific a_n arrray is not correct, "set_an" is not successful.')
            warning('Because the specific a_n arrray is not correct, "set_an" is not successful.')
            return
        end
    end
    
    
    len_an=cellfun(@(x) length(x),an);
    for i=1:length(len_an)
        if sum(len_an==len_an(i))~=length(len_an) || len_an(i)==0
             obj.addLog('warning: Because the specific a_n arrray is not correct, "set_an" is not successful.')
             warning('Because the specific a_n arrray is not correct, "set_an" is not successful.')
             return
        end
    end
    
    obj.an=an;
end