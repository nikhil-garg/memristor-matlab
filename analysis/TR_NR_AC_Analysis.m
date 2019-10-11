% Newton-Raphson AC analysis for trapezoidal Euler
% Inputs:
%   SimParam: simulation parameter struct
%   init_values: the given initial voltaegs or currents at corresponding nodes
%   pre_voltage: the voltaegs or currents values at previous time step
%   input: input current/voltage sources 
%   pre_input: previous input current/voltage sources
%   step_size: time step size
%   first_time: first time for AC analysis
%   reiter: is the step size shrinking for reiteration?
% Outputs:
%   result: the dc solution
%   f: induced currents and charges at current time instant
%   converged: 1 for converged, 0 for non converged
%   tot_it: total iteration
function [result f converged tot_it LTE] = TR_NR_AC_Analysis(SimParam, init_values, pre_voltage, ...
                                                             input, pre_input, step_size, first_time, reiter)  
    %perform AC analysis
    converged = 0;
    tot_it = 1;
    voltage = init_values;
    for it = reiter:SimParam.max_iter
        % 0 is initial value for gnd; should always be 0
        [spm_c spm_g next_f] = BSIM3Eval( SimParam.instance, [0; voltage], step_size, 'tran', first_time, it);
        first_time = 0; %make sure first_time is set as 0 after calling BSIM3Eval
        
        Cnl = (SimParam.Cl + spm_c);
        T = 2*Cnl/step_size + (SimParam.Gl + spm_g);
        % current input + next input in trapezoidal method
        b = (2*SimParam.Cl/step_size-(SimParam.Gl + spm_g))*pre_voltage + SimParam.B*(input + pre_input) + next_f + SimParam.f;       
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

    %LTE = 1/12*h^3*second derivative
    %1st derivative
    cur_dxdt = (voltage - pre_voltage)/step_size;
    pre_dxdt = SimParam.pre_dxdt;
    %initial condition
    if (norm(pre_dxdt, 2) == 0)
        pre_dxdt = cur_dxdt;
    end
    LTE = step_size^3/12*(cur_dxdt - pre_dxdt)/step_size; 

    result = voltage;
    f = next_f;
end
