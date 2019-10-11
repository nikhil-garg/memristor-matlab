%perform DC analysis using BSIM3 model 
% Inputs:
%   SimParam: simulation parameter struct
%   init_values: the given initial voltaegs or currents at corresponding nodes
%   input: input current/voltage sources 
% Outputs:
%   result: the dc solution
%   tot_it: total iteration
%   converged: 1 for converged, 0 for non converged
%   f_mexp: transistor currents for MEXP formulation 
function [result tot_it converged f_mexp] = DC_Analysis(SimParam, init_values, input)
    
    %perform DC analysis
    converged = 0;
    tot_it = 1;
    voltage = init_values;
    step_size = 1; %unused in dc mode
    
    for it = 1:SimParam.max_iter
        % 0 is initial value for gnd; should always be 0
        % f includes Gnl*x_k + i(x_k), should calculate x_{k+1} = x_{k} - f(x_k)/f'(x_k)
        % instead of dx = J\F
        [spm_c spm_g f] = BSIM3Eval( SimParam.instance, [0; voltage], step_size, 'dc', it, it);

        
        T = SimParam.Gl + spm_g;
        b = SimParam.B*input;
        b(1:size(f,1)) = b(1:size(f,1)) + f;
        x = T\b;
        dx = x - voltage;
    
        %update with current solution
        voltage = x;
    
        if (norm(dx) < SimParam.iter_err_tol)
            %last evaluation for starting transient analysis, set iter_num as -1
            [spm_c spm_g f f_mexp] = BSIM3Eval( SimParam.instance, [0; voltage], step_size, 'dc', it, -1);            
            T = SimParam.Gl + spm_g;
            b = SimParam.B*input;
            b(1:size(f,1)) = b(1:size(f,1)) + f;
            x = T\b;

            tot_it = it;
            converged = 1;
            break;
        end
    end

    result = x;
end
