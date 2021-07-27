classdef AFDCal  < handle
    % AFD calculation model
    
    properties (SetAccess = private)
        s % original input signal
        G % input signal after hilbert transform
        t % phase define
        S1 % energy distribution
        max_loc % location of maximum energy
        Weight % weight for computing integration
        an % searching result of basis parameter
        coef % decomposition result of decomposition coefficients
        level % decomposition level -> initial level is 0
        dic_an % searching dictionary of an
        Base % evaluators of searching an
        remainder % decomposition remainder
        tem_B % decomposition result of decomposition basis
        deComp % decomposition component
        decompMethod % set decomposition method: 
                     %     1: Single Channel Conventional AFD (default)
                     %     2: Single Channel Fast AFD
                     %     3. Multi-channel Conventional AFD
                     %     4. Multi-channel Fast AFD
        dicGenMethod % set dictionary generation method:
                     %     1: square (default)
                     %     2: circle (Fast AFD only uses 'circle')
        AFDMethod % set AFD method:
                  %     1: core (default)
                  %     2: unwinding
        log % log information
        run_time % running time of decomposition
        time_genDic % running time of generating searching dictionary
        time_genEva % running time of generating evaluators
        
        r_store % zeros for unwinding
        InProd % inner product for unwinding
        OutProd % outer product for unwinding
        Base_r % evaluators of searching zeros
        N_r % largest number of iterations for searching zeros
            % Normally, it is a large number. Default is 1e3.
        tol_r % tol for searching zeros
              % This number should be small enough. Default is 1e-3.
    end
    
    
    
    methods
        function obj = AFDCal(varargin)
            % Init AFD calculation model
            % AFDCal(inputSig) or AFDCal()
            
            obj.log={};
            
            if length(varargin)>1
                error('Error: too many inputs. Please only give the processed signal or leave the input as empty for further configuration.')
            elseif length(varargin)==1
                obj.setInputSignal(varargin{1})
            elseif length(varargin)<1
                obj.setInputSignal([])
            end
            
        end
        
        
    end
    
    methods (Static)
        ret = e_a(a,z)
        ret = e_a_r(a,z)
        ret = Unit_Disk(dist,cont)
        ret = Circle_Disk(dist,cont,phase)
        plot_sig(t,s,xlab,ylab)
        plot_point(t,s,xlab,ylab)
        ret = intg( f,g,Weigth)
        ret = blaschke1(r,t)
    end
end

