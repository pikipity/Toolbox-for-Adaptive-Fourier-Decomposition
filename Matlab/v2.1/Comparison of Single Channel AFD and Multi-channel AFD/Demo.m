clear;clc;close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Demo 1: Compare basis components obtained from the single channel AFD and MAFD
disp('Demo 1: Compare basis components obtained from the single channel AFD and MAFD')
% Construct original signal
load('demo_decomposition_basis.mat')
X_new=S1.'*unwright_decomp;
unwright_decomp=unwright_decomp(2:end,:);
% MAFD
N=2;
[S1, a, r_store, unwright_decomp_new]=AFD(1,X_new,N,0.1,0.95);
unwright_decomp_new=unwright_decomp_new(2:end,:);
% single channel AFD
[~, ~, ~, unwright_decomp_new_single]=AFD(2,X_new,N,0.1,0.95);
for ch=1:size(X_new,1)
    unwright_decomp_new_single{ch}=unwright_decomp_new_single{ch}(2:end,:);
end
% plot decomposition components
color_sel=[0      0.4470 0.7410;
           0.8500 0.3250 0.0980;
           0.9290 0.6940 0.1250;
           0.4940 0.1840 0.5560;
           0.4660 0.6740 0.1880;
           0.3010 0.7450 0.9330;
           0.6350 0.0780 0.1840];
legend_label={'Original basis component','Obtained basis components'};
h_figure=figure;
for n=1:2
    subplot(2,2,2*(n-1)+1)
    plot(t,real(unwright_decomp(n,:))/400,'linewidth',3,'color',color_sel(1,:))
    hold on
    plot(t,real(unwright_decomp_new(n,:))/400,'linewidth',3,'color',color_sel(2,:))
    grid on
    title(['Real Part, Decomposition level: ' num2str(n)])
    set(gca,'fontsize',10)
    xaxis([min(t) max(t)])
    R=corrcoef(real(unwright_decomp(n,:)).'/400,real(unwright_decomp_new(n,:)).'/400);
    disp(R(1,2));
    
    
    
    subplot(2,2,2*(n-1)+2)
    plot(t,imag(unwright_decomp(n,:))/400,'linewidth',3,'color',color_sel(1,:))
    hold on
    plot(t,imag(unwright_decomp_new(n,:))/400,'linewidth',3,'color',color_sel(2,:))
    grid on
    title(['Imaginary Part, Decomposition level: ' num2str(n)])
    set(gca,'fontsize',10)
    xaxis([min(t) max(t)])
    R=corrcoef(imag(unwright_decomp(n,:)).'/400,imag(unwright_decomp_new(n,:)).'/400);
    disp(R(1,2));
end
set(gcf,'position',[0 0         1543         269]);
saveas(h_figure,'Demo_Results/Demo1_Basis_components_MAFD.jpg')
close(h_figure)
%
h_figure=figure;
for n=1:2
    subplot(2,2,2*(n-1)+1);hold on
    plot(t,real(unwright_decomp(n,:))/400,'linewidth',3,'color',color_sel(1,:))
    plot(t,real(unwright_decomp_new_single{1}(n,:))/400,'linewidth',3,'color',color_sel(2,:))
    grid on
    title(['Real Part, Decomposition level: ' num2str(n) ', ch 1'])
    set(gca,'fontsize',10);hold on
    xaxis([min(t) max(t)])
    R=corrcoef(real(unwright_decomp(n,:)).'/400,real(unwright_decomp_new_single{1}(n,:)).'/400);
    disp(R(1,2));
    
    subplot(2,2,2*(n-1)+2);hold on
    plot(t,imag(unwright_decomp(n,:))/400,'linewidth',3,'color',color_sel(1,:))
    plot(t,imag(unwright_decomp_new_single{1}(n,:))/400,'linewidth',3,'color',color_sel(2,:))
    grid on
    title(['Imaginary Part, Decomposition level: ' num2str(n) ', ch 1'])
    set(gca,'fontsize',10)
    xaxis([min(t) max(t)])
    R=corrcoef(imag(unwright_decomp(n,:)).'/400,imag(unwright_decomp_new_single{1}(n,:)).'/400);
    disp(R(1,2));
end
set(gcf,'position',[0 0        1543         269]);
saveas(h_figure,'Demo_Results/Demo1_Basis_components_single_channel_AFD_ch1.jpg')
close(h_figure)
%
h_figure=figure;
for n=1:2
    subplot(2,2,2*(n-1)+1);hold on
    plot(t,real(unwright_decomp(n,:))/400,'linewidth',3,'color',color_sel(1,:))
    plot(t,real(unwright_decomp_new_single{2}(n,:))/400,'linewidth',3,'color',color_sel(2,:))
    grid on
    title(['Real Part, Decomposition level: ' num2str(n) ', ch 2'])
    set(gca,'fontsize',10);hold on
    xaxis([min(t) max(t)])
    R=corrcoef(real(unwright_decomp(n,:)).'/400,real(unwright_decomp_new_single{2}(n,:)).'/400);
    disp(R(1,2));
    
    subplot(2,2,2*(n-1)+2);hold on
    plot(t,imag(unwright_decomp(n,:))/400,'linewidth',3,'color',color_sel(1,:))
    plot(t,imag(unwright_decomp_new_single{2}(n,:))/400,'linewidth',3,'color',color_sel(2,:))
    grid on
    title(['Imaginary Part, Decomposition level: ' num2str(n) ', ch 2'])
    set(gca,'fontsize',10)
    xaxis([min(t) max(t)])
    R=corrcoef(imag(unwright_decomp(n,:)).'/400,imag(unwright_decomp_new_single{2}(n,:)).'/400);
    disp(R(1,2));
end
set(gcf,'position',[0 0        1543         269]);
saveas(h_figure,'Demo_Results/Demo1_Basis_components_single_channel_AFD_ch2.jpg')
close(h_figure)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Demo 2: Energy Convergence Rate
disp('Demo 2: Energy Convergence Rate')
% Load original signal
load('demo_energy_convergence.mat')
% MAFD
N=11;
[~, ~, ~, ~, F]=AFD(1,X,N,0.1,0.95);
% Reconstruct signal
reconstrct_X=zeros(N,size(X,1),size(X,2));
energy_error=zeros(1,N);
for n=1:N
    for ch=1:size(X,1)
        reconstrct_X(n,ch,:)=squeeze(sum(F(1:n,ch,:),1)).';
    end
    error=X-squeeze(reconstrct_X(n,:,:));
    energy_error(n)=sum(sum(abs(error)));
end
reconstrct_X=reconstrct_X(2:end,:,:);
% plot results
color_sel=[0      0.4470 0.7410;
           0.8500 0.3250 0.0980;
           0.9290 0.6940 0.1250;
           0.4940 0.1840 0.5560;
           0.4660 0.6740 0.1880;
           0.3010 0.7450 0.9330;
           0.6350 0.0780 0.1840];

h_figure=figure;
xyaxis=[0 2*pi -0.5 1.1;
        0 2*pi -0.7 1.1];
for ch=1:size(X,1)
    subplot(size(X,1),1,ch)
    plot(t,real(X(ch,:)),'linewidth',3,'color',color_sel(1,:))
    hold on
    plot(t,squeeze(real(reconstrct_X(1,ch,:))),'linewidth',3,'color',color_sel(2,:))
    axis(xyaxis(ch,:));
    title(['Decomposition level: 1, ch ' num2str(ch)])
    grid on
    set(gca,'fontsize',10)
end
set(gcf,'position',[0 0         827         307]);
saveas(h_figure,'Demo_Results/Demo2_Reconstruct_signal_level_1.jpg')
close(h_figure)

h_figure=figure;
xyaxis=[0 2*pi -0.5 1.1;
        0 2*pi -0.7 1.1];
for ch=1:size(X,1)
    subplot(size(X,1),1,ch)
    plot(t,real(X(ch,:)),'linewidth',3,'color',color_sel(1,:))
    hold on
    plot(t,squeeze(real(reconstrct_X(2,ch,:))),'linewidth',3,'color',color_sel(2,:))
    axis(xyaxis(ch,:));
    title(['Decomposition level: 2, ch ' num2str(ch)])
    grid on
    set(gca,'fontsize',10)
end
set(gcf,'position',[0 0        827         307]);
saveas(h_figure,'Demo_Results/Demo2_Reconstruct_signal_level_2.jpg')
close(h_figure)

h_figure=figure;
xyaxis=[0 2*pi -0.5 1.1;
        0 2*pi -0.7 1.1];
for ch=1:size(X,1)
    subplot(size(X,1),1,ch)
    plot(t,real(X(ch,:)),'linewidth',3,'color',color_sel(1,:))
    hold on
    plot(t,squeeze(real(reconstrct_X(4,ch,:))),'linewidth',3,'color',color_sel(2,:))
    axis(xyaxis(ch,:));
    title(['Decomposition level: 4, ch ' num2str(ch)])
    grid on
    set(gca,'fontsize',10)
end
set(gcf,'position',[0 0        827         307]);
saveas(h_figure,'Demo_Results/Demo2_Reconstruct_signal_level_4.jpg')
close(h_figure)

h_figure=figure;
xyaxis=[0 2*pi -0.5 1.1;
        0 2*pi -0.7 1.1];
for ch=1:size(X,1)
    subplot(size(X,1),1,ch)
    plot(t,real(X(ch,:)),'linewidth',3,'color',color_sel(1,:))
    hold on
    plot(t,squeeze(real(reconstrct_X(6,ch,:))),'linewidth',3,'color',color_sel(2,:))
    axis(xyaxis(ch,:));
    title(['Decomposition level: 6, ch ' num2str(ch)])
    grid on
    set(gca,'fontsize',10)
end
set(gcf,'position',[0 0         827         307]);
saveas(h_figure,'Demo_Results/Demo2_Reconstruct_signal_level_6.jpg')
close(h_figure)

h_figure=figure;
xyaxis=[0 2*pi -0.5 1.1;
        0 2*pi -0.7 1.1];
for ch=1:size(X,1)
    subplot(size(X,1),1,ch)
    plot(t,real(X(ch,:)),'linewidth',3,'color',color_sel(1,:))
    hold on
    plot(t,squeeze(real(reconstrct_X(10,ch,:))),'linewidth',3,'color',color_sel(2,:))
    axis(xyaxis(ch,:));
    title(['Decomposition level: 10, ch ' num2str(ch)])
    grid on
    set(gca,'fontsize',10)
end
set(gcf,'position',[0 0         827         307]);
saveas(h_figure,'Demo_Results/Demo2_Reconstruct_signal_level_10.jpg')
close(h_figure)

h_figure=figure;
plot(0:N-1,energy_error./energy_error(1),'x-','linewidth',3,'markersize',12,'color',color_sel(2,:))
grid on
xlabel('Decomposition Level')
ylabel('Relative Energy Ratio')
set(gca,'fontsize',10)
set(gca,'XTick',0:10)
axis([0 10 0 1.1])
set(gcf,'position',[0 0        611         335]);
saveas(h_figure,'Demo_Results/Demo2_Energy_convergence.jpg')
close(h_figure)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Demo 3: Time-frequency distribution
disp('Demo 3: Time-frequency distribution')

fs=400;
t=(0:4*fs)./fs;

snr_range=-10:0.5:10;
trial_Num=30;
power_ratio_res=[];

f_in=[10 11;...
      40 41;
      100 101];
freq_determine_range=0.05;

for session_n=1:size(f_in,1)
    for trial_n=1:trial_Num
        for snr_in=1:length(snr_range)
           fprintf('Session %d, Trial %d, SNR_n: %d\n',session_n,trial_n,snr_in)
           
           x=[awgn(sin(2*pi*f_in(session_n,1)*t),snr_range(snr_in));...
              awgn(sin(2*pi*f_in(session_n,2)*t),snr_range(snr_in))];
          
           time=[];
           frequency=[];
           TF_dist=[];
           
           if session_n==1
               winLen=fs;
           elseif session_n==2
               winLen=20;
           elseif session_n==3
               winLen=20;
           end
           
           for t_i=1:winLen:size(x,2)-winLen
               hilbert_x=[];
               for ch=1:size(x,1)
                    hilbert_x(ch,:)=hilbert(x(ch,t_i:t_i+(winLen-1)));
               end
               [S1,a,r_store,unwright_decomp]=AFD(1,hilbert_x,50,0.02,0.01);
               [time(t_i:t_i+(winLen-1)),frequency,TF_dist(:,t_i:t_i+(winLen-1))] = ...
                   multi_AFD_TF_dist(S1,a,r_store,size(hilbert_x,2),fs,0.05);
               if t_i>1
                    time(t_i:t_i+(winLen-1))=time(t_i:t_i+(winLen-1))+(time(t_i-1)+time(t_i-1)-time(t_i-2));
               end
           end
           [~,min_f_lim_i(1,1)]=min(abs(frequency-(f_in(session_n,1)-freq_determine_range)));
           [~,max_f_lim_i(1,1)]=min(abs(frequency-(f_in(session_n,1)+freq_determine_range)));
           [~,min_f_lim_i(1,2)]=min(abs(frequency-(f_in(session_n,2)-freq_determine_range)));
           [~,max_f_lim_i(1,2)]=min(abs(frequency-(f_in(session_n,2)+freq_determine_range)));
           f_range_select=unique([min_f_lim_i(1,1):max_f_lim_i(1,1),...
                                  min_f_lim_i(1,2):max_f_lim_i(1,2)]);
           power_ratio_res(session_n,trial_n,snr_in)=sum(sum(TF_dist(f_range_select,:)))/sum(sum(TF_dist(setdiff(1:length(frequency),f_range_select),:)));
        end
    end
end

color_sel=[0      0.4470 0.7410;
           0.8500 0.3250 0.0980;
           0.9290 0.6940 0.1250;
           0.4940 0.1840 0.5560;
           0.4660 0.6740 0.1880;
           0.3010 0.7450 0.9330;
           0.6350 0.0780 0.1840];
h_figure=figure;
for session_n=1:size(f_in,1)
    subplot(1,size(f_in,1),session_n)
    hold on
    shadedErrorBar(snr_range,squeeze(power_ratio_res(session_n,:,1:length(snr_range))),{@mean @cal_CI95},...
          'lineProps',{'o-','color',color_sel(1,:),'linewidth',3,'markersize',3,'MarkerFaceColor','w'},...
          'patchSaturation',0.13)
    grid on
    set(gca, 'YScale', 'log')
    axis([-10 10 1e-3 1e0])
    title(['f_1=' num2str(f_in(session_n,1)) ' Hz, f_2=' num2str(f_in(session_n,2)) ' Hz'])
    xlabel('Noise Level (dB)','fontsize',10)
    ylabel('Power Ratio','fontsize',10)
    set(gca,'fontsize',10)
    set(gcf,'position',[0 0   560   420])
end
set(gcf,'position',[0 0 951   298])
saveas(h_figure,'Demo_Results/Demo3_Power_ratio_sinusoidal_oscillation.jpg')
close(h_figure)