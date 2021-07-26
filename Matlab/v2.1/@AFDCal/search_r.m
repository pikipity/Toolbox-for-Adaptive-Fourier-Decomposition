function search_r(obj,ch_i)
% search_r() or search_r(N) or search_r(N,tol)

    N=obj.N_r;
    tol=obj.tol_r;

    f_r=obj.remainder;
    
%     K=size(obj.G,1);
%     for ch_i=1:K
        obj.r_store{ch_i,obj.level+1}=[];
        for j = 1:N
            switch obj.decompMethod
                case 'Single Channel Conventional AFD'
                    % S
                    S=[];
                    for i=1:size(obj.Base_r{ch_i,1},1)
                        S(i,:) = conj(squeeze(obj.Base_r{ch_i,1}(i,:,:))*(f_r(ch_i,:)'.*obj.Weight));
                    end
                    [min_row_i,min_col_i]=find(S==min(min(S)));
                    min_row_i=min_row_i(1);
                    min_col_i=min_col_i(1);
                    min_S=abs(min(min(S)));
                    % r
                    r=obj.dic_an{ch_i,1}(min_row_i,min_col_i);
                case 'Single Channel Fast AFD'
                    % S
                    phase_a=obj.t(ch_i,:);
                    Base=squeeze(obj.Base_r{ch_i,1}(1,:,:)); 
                    S=ifft(repmat(fft(f_r(ch_i,:).*obj.Weight.',length(phase_a)),size(Base,1),1).*Base,length(phase_a),2);
                    [min_row_i,min_col_i]=find(S==min(min(S)));
                    min_row_i=min_row_i(1);
                    min_col_i=min_col_i(1);
                    min_S=abs(min(min(S)));
                    %
                    r=obj.dic_an{ch_i,1}(min_row_i).*exp(1j.*phase_a(min_col_i));
            end
            % f_r
            f_r(ch_i,:)=f_r(ch_i,:).*(1-conj(r)*exp(1i*obj.t(ch_i,:)))./(exp(1i*obj.t(ch_i,:))-r);
            % finish ?
            if(min_S/size(obj.t,2) > tol)
                break
            else
                obj.r_store{ch_i,obj.level+1}=[obj.r_store{ch_i,obj.level+1} r];
            end
        end
%     end
end