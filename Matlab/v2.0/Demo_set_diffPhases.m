clear classes;clear all;clc;
T=2;
fs=250;
% prepare input signal
load('ssvep.mat');
G=G(1:40,1:T*fs);
freqs=freqs(1:40);
phases=phases(1:40);
% prepare phase
trial_no=size(G,1);
n_period=zeros(1,trial_no);
for trial=1:trial_no
    n_period(1,trial)=T*freqs(trial);
    total_sample=size(G,2);
    sample_one_period=total_sample/n_period(1,trial);
    t(trial,:)=0:((1/fs)*(2*pi)/(1/freqs(trial))):((1/fs)*(2*pi)/(1/freqs(trial))*(total_sample-1));
    t(trial,:)=t(trial,:)+phases(trial);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Single Channel Conventional AFD, square searching dictionary, same phase (0~2\pi)
% init AFD computation module
afdcal=AFDCal(G);
% set phase
for ch_i=1:size(G,1)
    afdcal.setPhase(ch_i,t(ch_i,:));
end
% set decomposition method: Single Channel Conventional AFD
afdcal.setDecompMethod(1);
% set dictionary generation method: square
afdcal.setDicGenMethod(1);
% set AFD method: core
afdcal.setAFDMethod(1);
% generate searching dictionary
afdcal.genDic(0.1,0.95);
% generate evaluators
afdcal.genEva();
% initilize decomposition
afdcal.init_decomp()
% decomposition 50 levels
N=50;
for n=1:N
    disp(afdcal.level+1)
    afdcal.nextDecomp()
    [~,systemview]=memory;
    if 1-systemview.PhysicalMemory.Available/systemview.PhysicalMemory.Total>=85/100
        warning(['Memory is not enough -> Decomposition stop, current level: ' num2str(afdcal.level)])
        break
    end
end
% plot reconstructed signal
figure
reSig=afdcal.cal_reSig(50);
trial_no=5;
for trial=1:trial_no
    subplot(trial_no,1,trial);
    plot(afdcal.t(trial,:)./(2*pi),afdcal.s(trial,:))
    hold on
    plot(afdcal.t(trial,:)./(2*pi),reSig(trial,:))
    xlabel('Phase (2\pi)')
    title(['Stimulus Frequency: ' num2str(freqs(trial)) ' Hz'])
end