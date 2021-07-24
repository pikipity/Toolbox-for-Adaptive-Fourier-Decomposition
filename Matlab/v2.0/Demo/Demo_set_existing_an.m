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
G_1=G(1:8,:);
t_1=t(1:8,:);
G_2=G(9:16,:);
t_2=t(9:16,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% prepare a_n array
% init AFD computation module
afdcal=AFDCal(G_1);
% set phase
for ch_i=1:size(G_1,1)
    afdcal.setPhase(ch_i,t_1(ch_i,:));
end
% set decomposition method: Single Channel Conventional AFD
afdcal.setDecompMethod(1);
% set dictionary generation method: square
afdcal.setDicGenMethod(1);
% set AFD method: unwinding
afdcal.setAFDMethod(2);
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% decomposition based on existing a_n and zeros
% init AFD computation module
afdcal_noSearching=AFDCal(G_2);
% set phase
for ch_i=1:size(G_2,1)
    afdcal_noSearching.setPhase(ch_i,t_2(ch_i,:));
end
% set decomposition method: Single Channel Conventional AFD
afdcal_noSearching.setDecompMethod(1);
% set dictionary generation method: square
afdcal_noSearching.setDicGenMethod(1);
% set AFD method: unwinding
afdcal_noSearching.setAFDMethod(2);
% set a_n
afdcal_noSearching.set_an(afdcal.an);
% set zeros
afdcal_noSearching.set_r(afdcal.r_store);
% initilize decomposition without searching
afdcal_noSearching.init_decomp(0)
% decomposition 50 levels without searching
N=50;
for n=1:N
    disp(afdcal_noSearching.level+1)
    afdcal_noSearching.nextDecomp(0)
    [~,systemview]=memory;
    if 1-systemview.PhysicalMemory.Available/systemview.PhysicalMemory.Total>=85/100
        warning(['Memory is not enough -> Decomposition stop, current level: ' num2str(afdcal.level)])
        break
    end
end