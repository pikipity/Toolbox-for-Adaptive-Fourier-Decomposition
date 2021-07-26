function setPhase(obj,channel,phase)
% set phase for channel
% setPhase(channel,phase)
% phase:
%   default phase is from 0 to 2\pi
%   the size of phase should be 1*L
%   L is the sample number of input signal
    if isempty(obj.s)
        obj.addLog('error: Because there is not input signal, setting phase is not successful.')
        error('Because there is not input signal, setting phase is not successful.')
    end
    if channel>size(obj.s,1) || channel<0
        obj.addLog('error: Because the specified channel is not existed, setting phase is not successful.')
        error('Because the specified channel is not existed, setting phase is not successful.')
    end
    if size(phase,1)~=1 || size(phase,2)~=size(obj.s,2)
        obj.addLog('error: Because the size of phase is not correct, setting phase is not successful.')
        error('Because the size of phase is not correct, setting phase is not successful.')
    end
    
    obj.t(channel,:)=phase;
    
    obj.addLog(['Setting phase for channel ' num2str(channel) ' correctly'])
end