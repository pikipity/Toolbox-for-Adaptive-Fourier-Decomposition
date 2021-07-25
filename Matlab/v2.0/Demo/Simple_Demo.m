clear all;clc;
% prepare input signal
load('ECG.mat');
% init AFD computation module
afdcal=AFDCal();
afdcal.setInputSignal(G);
% generate searching dictionary
afdcal.genDic(0.02,0.95);
% generate evaluators
afdcal.genEva();
% initilize decomposition
afdcal.init_decomp();
% decomposition 50 levels
N=50;
for n=1:N
    afdcal.nextDecomp();
end
