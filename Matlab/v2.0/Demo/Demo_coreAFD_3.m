clear classes;clear all;clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Single Channel Fast AFD, circle searching dictionary, same phase (0~2\pi)
% prepare input signal
fileList={'ECG.mat',...
          'heavysine_signal.mat',...
          'doppler_signal.mat',...
          'bump_signal.mat',...
          'block_signal.mat'};
tmp={};
for i=1:length(fileList)
    load(fileList{i})
    tmp{1,i}=G;
end
min_sig_len=min(cellfun(@(x) length(x(1,:)),tmp));
G=[];
for i=1:length(tmp)
    G(i,:)=tmp{i}(1,1:min_sig_len);
end
% init AFD computation module
afdcal=AFDCal();
afdcal.setInputSignal(G);
afdcal.plot_ori_sig();
% set decomposition method: Single Channel Fast AFD
afdcal.setDecompMethod(2);
% generate searching dictionary
afdcal.genDic(0.02,0.95);
afdcal.plot_dic();
% generate evaluators
afdcal.genEva();
afdcal.plot_evaluator();
% initilize decomposition
afdcal.init_decomp();
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
% plot energy distribution at level 1
afdcal.plot_S1(1);
% plot decomposition basis at level 2
afdcal.plot_basis(2);
% plot decomposition component at level 3
afdcal.plot_decompComp(3);
% plot reconstruction signal of first 20 levels
afdcal.plot_reSig(20);
% plot energy rate
afdcal.plot_energyRate(afdcal.level);