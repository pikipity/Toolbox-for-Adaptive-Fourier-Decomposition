function errorFlag = checkInput(obj)
    % check inputSig 
    % errorFlag:
    %   empty: no error
    %   1: input is empty (warning)
    %   2: signal length is small (warning)
    %   3: too many dimention (error)
    errorFlag = [];
    
    if isempty(obj.s)
        errorFlag(1,end+1) = 1;
    else
        if size(obj.s,2)<=size(obj.s,1)
            errorFlag(1,end+1) = 2;
        end
        if length(size(obj.s))>2
            errorFlag(1,end+1) = 3;
        end
    end
    
    
end