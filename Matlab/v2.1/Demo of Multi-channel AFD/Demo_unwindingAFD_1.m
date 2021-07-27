clear classes;clear all;clc;
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Multi-channel Conventional AFD, square searching dictionary, same phase (0~2\pi)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% unwinding
% init AFD computation module
afdcal=AFDCal();
afdcal.setInputSignal(G);
% set decomposition method: Multi-channel Conventional AFD
afdcal.setDecompMethod(3);
% set searching dictionary generation method: square searching dictionary
afdcal.setDicGenMethod(1);
% set AFD method: unwinding AFD
afdcal.setAFDMethod(2);
% generate searching dictionary
afdcal.genDic(0.02,0.95);
% generate evaluators
afdcal.genEva();
% initilize decomposition
afdcal.init_decomp()
% decomposition 50 levels
N=20;
for n=1:N
    disp(afdcal.level+1)
    afdcal.nextDecomp()
    [~,systemview]=memory;
    if 1-systemview.PhysicalMemory.Available/systemview.PhysicalMemory.Total>=89/100
        warning(['Memory is not enough -> Decomposition stop, current level: ' num2str(afdcal.level)])
        break
    end
end
%% core
% init AFD computation module
afdcal_core=AFDCal();
afdcal_core.setInputSignal(G);
% set decomposition method: Multi-channel Conventional AFD
afdcal_core.setDecompMethod(3);
% set searching dictionary generation method: square searching dictionary
afdcal_core.setDicGenMethod(1);
% set AFD method: core AFD
afdcal_core.setAFDMethod(1);
% generate searching dictionary
afdcal_core.genDic(0.02,0.95);
% generate evaluators
afdcal_core.genEva();
% initilize decomposition
afdcal_core.init_decomp()
% decomposition 50 levels
N=20;
for n=1:N
    disp(afdcal_core.level+1)
    afdcal_core.nextDecomp()
    [~,systemview]=memory;
    if 1-systemview.PhysicalMemory.Available/systemview.PhysicalMemory.Total>=89/100
        warning(['Memory is not enough -> Decomposition stop, current level: ' num2str(afdcal_core.level)])
        break
    end
end

%% Compare energy ratio
energyRate = zeros(size(afdcal.G,1),N+1);
for ch_i=1:size(afdcal.G,1)
    for n=1:N+1
        if n==1
            tmp = real(afdcal.G(ch_i,:))-real(afdcal.deComp{ch_i,1}(1,:));
        else
            reSig = afdcal.cal_reSig(n-1);
            tmp = real(afdcal.G(ch_i,:))-real(reSig(ch_i,:));
        end
        energyRate(ch_i,n) = afdcal.intg(tmp,tmp,afdcal.Weight);
    end
    energyRate(ch_i,:) = energyRate(ch_i,:)./energyRate(ch_i,1);
end

figure('name',['Energy Rate of first ' num2str(afdcal.level) ' levels'])
for ch_i=1:size(afdcal.G,1)
    subplot(size(afdcal.G,1),1,ch_i)
    plot(0:afdcal.level,energyRate(ch_i,:),'x-') 
    grid on
    xlabel('Decomposition Level')
    ylabel('Reminder Energy Ratio')
end

energyRate = zeros(size(afdcal_core.G,1),N+1);
for ch_i=1:size(afdcal_core.G,1)
    for n=1:N+1
        if n==1
            tmp = real(afdcal_core.G(ch_i,:))-real(afdcal_core.deComp{ch_i,1}(1,:));
        else
            reSig = afdcal_core.cal_reSig(n-1);
            tmp = real(afdcal_core.G(ch_i,:))-real(reSig(ch_i,:));
        end
        energyRate(ch_i,n) = afdcal_core.intg(tmp,tmp,afdcal_core.Weight);
    end
    energyRate(ch_i,:) = energyRate(ch_i,:)./energyRate(ch_i,1);
end

for ch_i=1:size(afdcal_core.G,1)
    subplot(size(afdcal_core.G,1),1,ch_i)
    hold on
    plot(0:afdcal_core.level,energyRate(ch_i,:),'x-') 
    grid on
    xlabel('Decomposition Level')
    ylabel('Reminder Energy Ratio')
end

for ch_i=1:size(afdcal_core.G,1)
    subplot(size(afdcal_core.G,1),1,ch_i)
    tmp=fileList{ch_i};
    tmp=tmp(1:findstr(tmp,'.mat')-1);
    tmp=strrep(tmp,'_',' ');
    title(tmp)
    legend({'Unwinding','Core'})
end

%% Computational Time
time=[];
time(:,1)=sum([afdcal.time_genEva.' afdcal.time_genDic.' afdcal.run_time].');
time(:,2)=sum([afdcal_core.time_genEva.' afdcal_core.time_genDic.' afdcal_core.run_time].');
figure('name','Computational Time')
bar(time)
for ch_i=1:size(afdcal_core.G,1)
    tmp=fileList{ch_i};
    tmp=tmp(1:findstr(tmp,'.mat')-1);
    tmp=strrep(tmp,'_',' ');
end
grid on
xLabel={'Unwinding','Core'};
set(gca,'xticklabel',xLabel)
ylabel('Computational Time (s)')