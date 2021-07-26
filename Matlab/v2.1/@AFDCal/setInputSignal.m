function setInputSignal(obj,inputSig)
    % set input signal (All settings will be initialized)
    % setInputSignal(inputSig)
    % inputSig:
    %   first dimension is channel
    %   second dimension is sample
    obj.addLog(['------------------------- ' datestr(now,'dd-mm-yyyy HH:MM:SS.FFF AM') ' --------------------------------'])
    obj.s = inputSig;
    % check input
    errorFlag = obj.checkInput();
    if ~isempty(errorFlag)
        for error_i=1:length(errorFlag)
            switch errorFlag(error_i)
                case 1
                    obj.addLog('warning: Input is empty. Please remember to set a input signal by "setInputSignal"')
                    warning('Input is empty. Please remember to set a input signal by "setInputSignal"')
                case 2
                    obj.addLog('warning: Please double check input signal. The first dimension should be channel. The second dimension should be sample.')
                    warning('Please double check input signal. The first dimension should be channel. The second dimension should be sample.')
                case 3
                    obj.addLog('Error: The dimension of input signal is wrong. The input signal only can have 2 dimentions.')
                    error('The dimension of input signal is wrong. The input signal only can have 2 dimentions.')
            end
        end
    end
    % 
    obj.addLog('Input new signal')
    obj.addLog('Initialize settings')
    % init calculation settings
    obj.initSetting();
    % display class information
    obj.dispInfo();
    
    obj.addLog('Set input signal correctly')
end