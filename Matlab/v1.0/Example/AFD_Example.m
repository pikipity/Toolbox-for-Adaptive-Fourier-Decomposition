clear;clc;close all;
% Read signal G
load('bump_signal.mat')
% Decompose and reconstruct signal G using the AFD based on the conventional exhaustive
% searching
disp('Running conventional exhaustive searching')
tic;
[an_conv,coef_conv,t]=conv_AFD(G,50,50);
t_cost=toc;
disp(['Time Cost: ' num2str(t_cost)])
G_re_conv=real(inverse_AFD(an_conv,coef_conv,t));
figure(1)
plot(t,G,t,G_re_conv)
legend({'Original Signal','Conventional Exhaustive Searching'})
% Decompose and reconstruct signal G using the AFD based on the FFT
disp('Running FFT based exhaustive searching')
tic;
[an_FFT,coef_FFT,t]=FFT_AFD(G,50,50);
t_cost=toc;
disp(['Time Cost: ' num2str(t_cost)])
G_re_FFT=real(inverse_AFD(an_FFT,coef_FFT,t));
figure(2)
plot(t,G,t,G_re_FFT)
legend({'Original Signal','FFT-based Exhaustive Searching'})
% Decomposition components
[~,~,F_n]=comp_AFD(an_FFT,coef_FFT,t);
figure(3)
for n=1:6
    subplot(3,2,n)
    plot(t,real(F_n(n+1,:)));
    title(['n=' num2str(n)])
end
% Compare a_n searching results
figure(4)
plot(real(an_conv),imag(an_conv),'bo',real(an_FFT),imag(an_FFT),'rx')
axis([-1 1 -1 1])
xlabel('Re')
ylabel('Im')
legend({'Conventional Exhaustive Searching','FFT-based Exhaustive Searching'})