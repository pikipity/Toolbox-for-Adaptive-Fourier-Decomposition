function [time,frequency,TF_dist]=multi_AFD_TF_dist(S1,a,r_store,L,fs,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate time-frequency distribution based on MAFD
%
% [time,frequency,TF_dist]=multi_AFD_TF_dist(S1,a,r_store,L,fs)
% [time,frequency,TF_dist]=multi_AFD_TF_dist(S1,a,r_store,L,fs,freq_res)
%
% inputs:
%   S1: Coefficients
%   a: basis parameters for outer function
%   r_store: basis parameters for inner function
%   L: length of signal
%   fs: sampling frequency
%   freq_res: frequency resolution of the time-frequency distribution, default is 0.01 Hz
% outputs:
%   time: time scale of the time-frequency distribution
%   frequency: frequency scale of the time-frequency distribution
%   TF_dist: time-frequency distribution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargin<5
        error('Inputs are not enough')
    elseif nargin<6
        freq_res=0.01;
    elseif nargin==6
        freq_res=varargin{1};
    elseif nargin>6
        error('Too many inputs')
    end
    
    time_res=1/fs;
    n=length(a);
    pha = zeros(n,L);
    for j=1:n
        r=r_store{j};
        B(1,:) = blaschke1(r,L);
        if(isempty(r))
            pha(j,:) = 0;
        else
            [pha(j,:),~] = disp_uw(r,B(1,:));
        end
    end
    
    n_period=1;
    ch_l=size(S1,2);
    t=linspace(0,2*pi,L);
    
    phase_1 = [];
    amplitude = [];
    phase_1(1,:) = (abs(a(1)).*cos(t-angle(a(1)))-abs(a(1))^2)./ ...
                        (1-2*abs(a(1)).*cos(t-angle(a(1)))+abs(a(1))^2);
    for ch=1:ch_l
        amplitude(1,ch,:) = abs(S1(1,ch)).*((1-abs(a(1)^2))^0.5)./ ...
                         sqrt((1-2*abs(a(1)).*cos(t-angle(a(1)))+abs(a(1))^2));
    end
    
    for j=2:n
        for ch=1:ch_l
            amplitude(j,ch,:) = abs(S1(j,ch)).*((1-abs(a(j)^2))^0.5)./ ...
                             sqrt((1-2*abs(a(j)).*cos(t-angle(a(j)))+abs(a(j))^2));
        end
        phase_1(j,:) = (abs(a(j)).*cos(t-angle(a(j)))-abs(a(j))^2)./ ...
                       (1-2*abs(a(j)).*cos(t-angle(a(j)))+abs(a(j))^2)+ ...
                       (1-abs(a(j-1)).*cos(t-angle(a(j-1))))./ ...
                       (1-2.*abs(a(j-1)).*cos(t-angle(a(j-1)))+ ...
                       abs(a(j-1))^2)+phase_1(j-1,:);
    end
    
    phase1 = zeros(size(pha));
    tem = 0;
    for j = 1:n
        tem = tem+pha(j,:);
        phase1(j,:) = tem+phase_1(j,:);
    end
    phase1=phase1./(length(t)*(1/(n_period*fs)));
    
    actual_time=(1:length(t))./fs;
    time=min(actual_time):time_res:max(actual_time);
    frequency=linspace(0,1,fs/2/freq_res).*(fs/2);
    im1=zeros(ch_l,length(time),length(frequency));
    
    for k=1:size(amplitude,3)
        for j=1:size(amplitude,1)
%                 select_level(1,end+1)=j;
                [~,d]=min(abs(frequency-phase1(j,k)));
                [~,d1]=min(abs(time-actual_time(k)));
                for ch=1:ch_l
                    im1(ch,d1,d)=im1(ch,d1,d)+amplitude(j,ch,k).^2;
                end
        end
    end
    im1_ch=im1;
    im1=squeeze(sum(im1,1));
    im1_ch=sqrt(im1_ch);
    im1=sqrt(im1);
    
    TF_dist_ch=[];
    for ch=1:ch_l
        im1_ch_tmp=fliplr(squeeze(im1_ch(ch,:,:)))';
        TF_dist_ch(ch,:,:)=flipud(squeeze(im1_ch_tmp));
    end
    im1=fliplr(im1)';
    TF_dist=flipud(im1);
end

function B=blaschke1(a,L)
    t = linspace(0,2*pi,L);
    x = exp(1i*t);
    B = ones(size(t));
    if(isempty(a))
        B = ones(1,L);
    else
        a1 = a(abs(a)~=0);
        for k = 1:length(a1)
            B = B.*(x-a1(k))./(1-conj(a1(k))*x).*(-conj(a1(k))/abs(a1(k)));
        end
        n = length(a)-length(a1);
        B = B.*x.^n;
    end
end

function [pha,amplitude] = disp_uw(a,f)
    t = linspace(0,2*pi,length(f));
    phase_d = 0;
    amplitude = abs(f);
    for j = 1:length(a)
        phase_d = (1-abs(a(j))^2)./(1-2.*abs(a(j)).*cos(t-angle(a(j)))+ ...
            abs(a(j))^2)+phase_d;
    end
    Mphase_d = max(max(phase_d));
    phase_d = phase_d/Mphase_d;
    pha = phase_d*Mphase_d;
end