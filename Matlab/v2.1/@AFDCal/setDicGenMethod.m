function setDicGenMethod(obj,method_no)
    switch method_no
        case 1
            obj.dicGenMethod = 'square';
        case 2
            obj.dicGenMethod = 'circle';
        otherwise
            obj.addLog('error: Because the specific dicGenMethod is unknown, setDicGenMethod is not successful.')
            error('Because the specific dicGenMethod is unknown, setDicGenMethod is not successful.')
    end
    
    obj.addLog('setDicGenMethod is successful.')
end