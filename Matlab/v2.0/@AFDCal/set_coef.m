function set_coef(obj,coef)
    
    if size(coef,1)<size(obj.G,1)
        obj.addLog('warning: Because the specific coef arrray is not correct, "set_coef" is not successful.')
        warning('Because the specific coef arrray is not correct, "set_coef" is not successful.')
        return
    end
    
    len_an=cellfun(@(x) length(x),coef);
    for i=1:length(len_an)
        if sum(len_an==len_an(i))~=length(len_an) || len_an(i)==0
             obj.addLog('warning: Because the specific a_n arrray is not correct, "set_coef" is not successful.')
             warning('Because the specific a_n arrray is not correct, "set_coef" is not successful.')
             return
        end
    end
    
    obj.coef=coef;
end