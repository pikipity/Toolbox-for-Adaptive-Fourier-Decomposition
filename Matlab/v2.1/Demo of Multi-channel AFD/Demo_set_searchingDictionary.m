clear classes;clear all;clc;
% prepare input signal
fileList={'ECG.mat'};
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Multi-channel Conventional AFD, circle searching dictionary, same phase (0~2\pi)
% init AFD computation module
afdcal=AFDCal();
afdcal.setInputSignal(G);
% set decomposition method: Multi-channel Conventional AFD
afdcal.setDecompMethod(3);
% set dictionary generation method: circle
afdcal.setDicGenMethod(2);
% set AFD method: core
afdcal.setAFDMethod(1);
% generate searching dictionary manually. Generate magnitude and phase randomly
mag_an=[0.1:0.3:0.7 0.7:0.05:0.9];
ind=randperm(length(mag_an));
mag_an=mag_an(ind(1:5));
phase_an=0:0.1:(2*pi-0.1);
ind=randperm(length(phase_an));
phase_an=phase_an(ind(1:20));
dic_an{1,1}=[];
for i=1:length(mag_an)
    for j=1:length(phase_an)
        dic_an{1,1}=[dic_an{1,1} mag_an(i)*exp(1i*phase_an(j))];
    end
end
% set searching dictionary
afdcal.set_dic_an(dic_an); % dictionary generation method is automatically set as "square".
afdcal.plot_dic();
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