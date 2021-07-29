function [S1, a, r_store, unwright_decomp, F]=AFD(method_no,X,N,dist,max_an_mag)
    if method_no==1
        % multi-channel unwinding AFD
        AFD_no=3;
    elseif method_no==2
        % single channel unwinding AFD
        AFD_no=1;
    end
    afdcal=AFDCal(X); % initilize AFD
    afdcal.genWeight(2,size(X,2),6); % set weight for integration
    for i=1:size(X,1)
        afdcal.setPhase(i,linspace(0,2*pi,size(X,2))); % set phase
    end
    afdcal.setDecompMethod(AFD_no); % multi-channel core AFD
    afdcal.setAFDMethod(2); % unwinding
    afdcal.genDic(dist,max_an_mag);
    afdcal.genEva();
    afdcal.init_decomp(); % initilize decomposition
    for i=1:N
        afdcal.nextDecomp(); % decomposition
    end
    
    if method_no==1
        % multi-channel unwinding AFD
        S1=zeros(N+1,size(X,1),1);
        a = zeros(N+1,1);
        r_store=cell(1,N+1);
        unwright_decomp=zeros(N+1,size(X,2));
        F=zeros(N+1,size(X,1),size(X,2));
        for ch_l=1:size(X,1)
            S1(:,ch_l,1)=afdcal.coef{ch_l,1};
            a=afdcal.an{1,1}.';
            r_store=afdcal.r_store(1,:);
            unwright_decomp=afdcal.tem_B{1,1};
            F(:,ch_l,:)=afdcal.deComp{ch_l,1};
        end
    elseif method_no==2
        % single channel unwinding AFD
        for ch_l=1:size(X,1)
            S1{ch_l,1}=zeros(N+1,1,1);
            a{ch_l,1}=zeros(N+1,1);
            r_store{ch_l,1}=cell(1,N+1);
            unwright_decomp{ch_l,1}=zeros(N+1,size(X,2));
            F{ch_l,1}=zeros(N+1,1,size(X,2));
        
            S1{ch_l,1}(:,1,1)=afdcal.coef{ch_l,1};
            a{ch_l,1}=afdcal.an{ch_l,1}.';
            r_store{ch_l,1}=afdcal.r_store(ch_l,:);
            unwright_decomp{ch_l,1}=afdcal.tem_B{ch_l,1};
            F{ch_l,1}(:,1,:)=afdcal.deComp{ch_l,1};
        end
    end
end