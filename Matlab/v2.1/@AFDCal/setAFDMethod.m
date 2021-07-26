function setAFDMethod(obj,method_no)
    switch method_no
        case 1
            obj.AFDMethod = 'core';
        case 2
            obj.AFDMethod = 'unwinding';
        otherwise
            obj.addLog('error: Because the specific AFDMethod is unknown, setAFDMethod is not successful.')
            error('Because the specific AFDMethod is unknown, setAFDMethod is not successful.')
    end
    
    obj.addLog('setAFDMethod is successful.')
end