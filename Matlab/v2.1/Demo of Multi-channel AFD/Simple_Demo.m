clear all;clc;
T=2;
fs=250;
% prepare input signal
load('ssvep.mat');
G=G(1:40,1:T*fs);
% freqs=freqs(1:40);
% phases=phases(1:40);
% prepare phase
% trial_no=size(G,1);
% n_period=zeros(1,trial_no);
% for trial=1:trial_no
%     n_period(1,trial)=T*freqs(trial);
%     total_sample=size(G,2);
%     sample_one_period=total_sample/n_period(1,trial);
%     t(trial,:)=0:((1/fs)*(2*pi)/(1/freqs(trial))):((1/fs)*(2*pi)/(1/freqs(trial))*(total_sample-1));
%     t(trial,:)=t(trial,:)+phases(trial);
% end
% init AFD computation module
afdcal=AFDCal(G);
% set different phases for different channels 
% (this is not necessary)
% for ch_i=1:size(G,1)
%     afdcal.setPhase(ch_i,t(ch_i,:));
% end
% Multi-channel Conventional AFD
afdcal.setDecompMethod(4);
afdcal.setAFDMethod(2);
afdcal.setDicGenMethod(2);
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
