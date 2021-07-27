clear classes;clear all;clc;close all;
N=18;
%% prepare input signal
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Multi-channel Fast AFD, circle searching dictionary, core AFD, same phase (0~2\pi)
% init AFD computation module
afdcal_1=AFDCal();
afdcal_1.setInputSignal(G);
% set decomposition method: Multi-channel Fast AFD
afdcal_1.setDecompMethod(4);
% set AFD method: unwinding AFD
afdcal_1.setAFDMethod(2);
% generate searching dictionary
afdcal_1.genDic(0.02,0.95);
% generate evaluators
afdcal_1.genEva();
% initilize decomposition
afdcal_1.init_decomp();
% decomposition 50 levels
for n=1:N
    afdcal_1.nextDecomp()
    %
    [~,systemview]=memory;
    if 1-systemview.PhysicalMemory.Available/systemview.PhysicalMemory.Total>=89/100
        error(['Memory is not enough -> Decomposition stop'])
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Multi-channel Conventional AFD, square searching dictionary, core AFD, same phase (0~2\pi)
% init AFD computation module
afdcal_2=AFDCal();
afdcal_2.setInputSignal(G);
% set decomposition method: Multi-channel Conventional AFD
afdcal_2.setDecompMethod(3);
% set searching dictionary generation method: square searching dictionary
afdcal_2.setDicGenMethod(1);
% set AFD method: unwinding AFD
afdcal_2.setAFDMethod(2);
% generate searching dictionary
afdcal_2.genDic(0.02,0.95);
% generate evaluators
afdcal_2.genEva();
% initilize decomposition
afdcal_2.init_decomp()
% decomposition 50 levels
for n=1:N
    afdcal_2.nextDecomp();
    %
    [~,systemview]=memory;
    if 1-systemview.PhysicalMemory.Available/systemview.PhysicalMemory.Total>=89/100
        error(['Memory is not enough -> Decomposition stop'])
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Multi-channel Conventional AFD, circle searching dictionary, core AFD, same phase (0~2\pi)
% init AFD computation module
afdcal_3=AFDCal();
afdcal_3.setInputSignal(G);
% set decomposition method: Single Channel Conventional AFD
afdcal_3.setDecompMethod(3);
% set searching dictionary generation method: circle searching dictionary
afdcal_3.setDicGenMethod(2);
% set AFD method: unwinding AFD
afdcal_3.setAFDMethod(2);
% generate searching dictionary
afdcal_3.genDic(0.02,0.95);
% generate evaluators
afdcal_3.genEva();
% initilize decomposition
afdcal_3.init_decomp()
% decomposition 50 levels
for n=1:N
    afdcal_3.nextDecomp();
    %
    [~,systemview]=memory;
    if 1-systemview.PhysicalMemory.Available/systemview.PhysicalMemory.Total>=89/100
        error(['Memory is not enough -> Decomposition stop'])
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compare a_n
legLabel=fileList;
for i=1:length(legLabel)
    tmp=legLabel{i};
    tmp=tmp(1:findstr(tmp,'.mat')-1);
    tmp = strrep(tmp,'_',' ');
    legLabel{i}=tmp;
end
figure
for ch_i=1
    subplot(1,1,ch_i)
    hold on
    plot(real(afdcal_1.an{ch_i,1}(2:end)),imag(afdcal_1.an{ch_i,1}(2:end)),'o','markersize',10)
    plot(real(afdcal_2.an{ch_i,1}(2:end)),imag(afdcal_2.an{ch_i,1}(2:end)),'x','markersize',10)
    plot(real(afdcal_3.an{ch_i,1}(2:end)),imag(afdcal_3.an{ch_i,1}(2:end)),'x','markersize',10)
    grid on
    xlabel('Real')
    ylabel('Imag')
    xLabel={'Fast AFD (circle)','Conv AFD (square)','Conv AFD (circle)'};
    legend(xLabel,'Location','northeastoutside')
    axis([-1 1 -1 1])
    title(legLabel{ch_i})
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compare computational time
time_store=[];
mse_store=[];
% afdcal_1
time = [afdcal_1.time_genDic.',... 
        afdcal_1.time_genEva.',...
        afdcal_1.run_time];
time_store(:,1)=sum(time.');
reSig = afdcal_1.cal_reSig(afdcal_1.level);
mse = mean(((G-reSig).^2).').';
mse_store(:,1)=mse;
% afdcal_2
time = [afdcal_2.time_genDic.',... 
        afdcal_2.time_genEva.',...
        afdcal_2.run_time];
time_store(:,2)=sum(time.');
reSig = afdcal_2.cal_reSig(afdcal_2.level);
mse = mean(((G-reSig).^2).').';
mse_store(:,2)=mse;
% afdcal_3
time = [afdcal_3.time_genDic.',... 
        afdcal_3.time_genEva.',...
        afdcal_3.run_time];
time_store(:,3)=sum(time.');
reSig = afdcal_3.cal_reSig(afdcal_3.level);
mse = mean(((G-reSig).^2).').';
mse_store(:,3)=mse;
%
figure('name','Computational Time (Core AFD)')
bar(time_store.');
grid on
xLabel={'Fast AFD (circle)','Conv AFD (square)','Conv AFD (circle)'};
set(gca,'XTickLabel',xLabel)
ylabel('Computational Time (s)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MSE
figure('name','MSE (Core AFD)')
bar(mse_store);
grid on
legLabel=fileList;
for i=1:length(legLabel)
    tmp=legLabel{i};
    tmp=tmp(1:findstr(tmp,'.mat')-1);
    tmp = strrep(tmp,'_',' ');
    legLabel{i}=tmp;
end
xLabel={'Fast AFD (circle)','Conv AFD (square)','Conv AFD (circle)'};
legend(xLabel,'Location','northeastoutside')
set(gca,'XTickLabel',legLabel)
ylabel('MSE')
