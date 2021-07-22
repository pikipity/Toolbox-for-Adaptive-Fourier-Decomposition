function setDecompMethod(obj,method_no)
    switch method_no
        case 1
            obj.decompMethod = 'Single Channel Conventional AFD';
        case 2
            obj.decompMethod = 'Single Channel Fast AFD';
            obj.addLog('Fast AFD only can use the "circle" dictionary. So the dicGenMethod is changed.')
            obj.setDicGenMethod(2)
        otherwise
            obj.addLog('error: Because the specific decompMethod is unknown, setDecompMethod is not successful.')
            error('Because the specific decompMethod is unknown, setDecompMethod is not successful.')
    end
    
    obj.addLog('setDecompMethod is successful.')
end