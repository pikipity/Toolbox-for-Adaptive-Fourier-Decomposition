function set_parameters_searchingZeros(obj,N_r,tol_r)
% set_parameters_searchingZeros(N_r,tol_r)
% N_r % largest number of iterations for searching zeros
      % Normally, it is a large number. Default is 1e3.
% tol_r % tol for searching zeros
        % This number should be small enough. Default is 1e-3.
        
    obj.N_r = N_r;
    obj.tol_r = tol_r;
end