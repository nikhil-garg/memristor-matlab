% Newton-Raphson AC analysis for backward Euler
% Inputs:
%   SimParam: simulation parameter struct
%   init_values: the given initial voltaegs or currents at corresponding nodes
%   pre_voltage: the voltaegs or currents values at previous time step
%   input: input current/voltage sources 
%   step_size: time step size
%   first_time: first time for AC analysis
%   reiter: is the reiteration for shrunk step size
% Outputs:
%   result: the dc solution
%   converged: 1 for converged, 0 for non converged
%   tot_it: total iteration
%   LTE: local truncation error
function [result converged tot_it LTE] = BE_NR_AC_Analysis(SimParam, init_values, pre_voltage, ...
							    input, step_size, first_time, reiter)  
    %perform AC analysis
    converged = 0;
    tot_it = 1;
    voltage = init_values;
    for it = reiter:SimParam.max_iter
        % 0 is initial value for gnd; should always be 0
        [spm_c spm_g f] = BSIM3Eval( SimParam.instance, [0; voltage], step_size, 'tran', first_time, it);
        first_time = 0; %make sure first_time is set as 0 after calling BSIM3Eval
        
        Cnl = (SimParam.Cl + spm_c);
        T = Cnl/step_size + (SimParam.Gl + spm_g);
        b = SimParam.Cl/step_size*pre_voltage + SimParam.B*input + f;       
        x = T\b;
        dx = x - voltage;
    
        if (norm(dx, 1) < SimParam.iter_err_tol)
            tot_it = it;
            converged = 1;
    	    voltage = x;
            break;
        end
        
        %update voltage with new solution x
        voltage = x;
    end
    
    %LTE
    %there is a numerical bug in LTE computation
    dxdt = (voltage - pre_voltage)/step_size;
    pre_dxdt = SimParam.pre_dxdt;
    if (norm(pre_dxdt, 2) == 0)
        pre_dxdt = dxdt;
    end
    LTE = step_size^2/2*(dxdt - pre_dxdt)/step_size;
    

    result = x;

end