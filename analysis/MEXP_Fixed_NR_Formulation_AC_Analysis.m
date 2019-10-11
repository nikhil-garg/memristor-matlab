% Newton-Raphson AC analysis for MEXP
% Inputs:
%   SimParam: simulation parameter structure
%   ptr_instance: the pointer to the BSIM3 instances in the circuit
%   init_values: the given initial voltaegs or currents at corresponding nodes
%   pre_voltage: the voltaegs or currents values at previous time step
%   input: input current/voltage sources 
%   pre_input: input current voltage sources at previous time step
%   step_size: time step size
%   first_time: first time for AC analysis
% Outputs:
%   result: the dc solution
%   tot_it: total iteration
%   converged: 1 for converged, 0 for non converged
function [result tot_it converged] = MEXP_Fixed_NR_Formulation_AC_Analysis(SimParam, init_values, pre_voltage, pre_pre_voltage, ...
                                                                            input, pre_input, step_size, first_time)
    %global variable - states of f
    global f_states;
      
    %perform AC analysis
    converged = 0;
    tot_it = 1;
    voltage = init_values;

    %calculate the linear terms (see TCAD/ICCAD paper)
    %get nonlineaer C G f in the previous state
    [spm_c spm_g dummy f spm_ec] = BSIM3Eval( SimParam.instance, [0; voltage], step_size, 'tran', first_time, 1);
    first_time = 0; %set first_time as 0 after caling BSIM3Eval  
    C = SimParam.Cl + spm_ec; %assume nonlinear C spm_c varies mildly within this step
    G = SimParam.Gl + spm_g;
    
    %TODO
    %check regularization(?)
    f = (f - spm_g*pre_voltage - (spm_c-spm_ec)*(pre_voltage - pre_pre_voltage));
    v = pre_voltage; % + C\(step_size/2*f);
    alpha = step_size/10;
    [Ctmp Gtmp v_tmp] = ConstructOneMEXP(C, SimParam.Gl, SimParam.B, v, step_size, alpha, input, pre_input, f);
       
    %calulate the result of linear part
    T = Ctmp\Gtmp*(step_size/alpha);
    tmp_f = EXP0(T, v_tmp); 
    L = tmp_f(1:SimParam.max_node_num);% + EXP0(-C\G*2*step_size, -f_states(:,2)*5/24)+EXP0(-C\G*3*step_size, f_states(:,3)/24);    
    
    %calculate the result of nonlinear part by NR method
    v_old = pre_voltage;
    f_old = f;
    for it = 2:SimParam.max_iter
        % 0 is initial value for gnd; should always be 0
        [spm_c spm_g dummy f spm_ec] = BSIM3Eval( SimParam.instance, [0; voltage], step_size, 'tran', first_time, it);
        first_time = 0; %set first_time as 0 after caling BSIM3Eval
        
        Cnl = (SimParam.Cl + spm_ec);
        Gnl = (SimParam.Gl + spm_g);

        %formulation 1
        %x = L + C\(step_size/2*f);
        
        %formulation 2
        %x = L + EXP1(-(Cnl\Gnl)*step_size, Cnl\(f*step_size/2));
        
        %formulation 3
        %x = L + EXP1(-(Cnl\(Gl+rG))*step_size, (Cnl)\((f - spm_g * voltage)*step_size)/2);
        
        %formulation 4
        tt = (f - spm_g*voltage - (spm_c-spm_ec)*(voltage - pre_voltage)/step_size);        
        
        %x = (C\tt)step_size/2 + L;
        x = L + EXP2(-C\SimParam.Gl*step_size, C\(tt - f_old)*step_size);
        dx = x - voltage;
                
        if (norm(dx, 1) < SimParam.iter_err_tol)
            tot_it = it;
            converged = 1;
            voltage = x;
            break;
        end
        
        %update voltage with new solution x
        v_old = voltage;
        voltage = x;
    end
    
    if (converged ~= 1)
        converged
    end
    
    %update state of f
    f_states(:, 2:end) = f_states(:, 1:end-1);
    f_states(:, 1) = C\tt*step_size;
    
    result = voltage;
    
end
