% Fixed-point AC analysis for MEXP
% Inputs:
%   SimParam: simulation parameter struct
%   ptr_instance: the pointer to the BSIM3 instances in the circuit
%   init_values: the given initial voltaegs or currents at corresponding nodes
%   pre_voltage: the voltaegs or currents values at previous time step
%   Gl:	G matrix of linear components
%   Cl: C matrix of linear components
%   B:	B matrix in state equation
%   input: input current/voltage sources 
%   pre_input: input current voltage sources at previous time step
%   step_size: time step size
%   first_time: first time for AC analysis
%   (optional) err_tol: error tolerance for convergence
%   (optional) max_iter: maximum number of iterations
% Outputs:
%   result: the dc solution
%   tot_it: total iteration
%   converged: 1 for converged, 0 for non converged
function [result tot_it converged] = MEXP_Fixed_AC_Analysis(SimParam, init_values, pre_voltage, ...
                                                            input, pre_input, step_size, first_time)
   
    %perform AC analysis
    converged = 0;
    tot_it = 1;
    voltage = init_values;   

    %calculate the linear terms (see TCAD/ICCAD paper)
    %get nonlineaer C G f in the previous state
    %'it' is set as 1 for internal state transition
    [spm_c spm_g dummy f spm_ec] = BSIM3Eval( SimParam.instance, [0; voltage], step_size, 'tran', first_time, 1);
    first_time = 0; %set first_time as 0 after caling BSIM3Eval

    C = SimParam.Cl + spm_ec; %assume nonlinear C spm_c varies mildly within this step
    G = SimParam.Gl + spm_g;
    
    %TODO
    %check regularization(?)

    %construct one exponential formular
    %formulation 1
    %v = pre_voltage + C\(step_size/2*f);
    %[Ctmp Gtmp v_tmp alpha] = ConstructOneMEXP(C, G, B, v, step_size, input, pre_input);
    
    %formulation 2
    %v = pre_voltage;
    %[Ctmp Gtmp v_tmp alpha] = ConstructOneMEXP(C, G, B, v, step_size, input, pre_input, f/2);
      
    %formulation 3
    %v = pre_voltage;
    %[Ctmp Gtmp v_tmp alpha] = ConstructOneMEXP(C, Gl+rG, B, v, step_size, input, pre_input, (f - spm_g*pre_voltage)/2);
    
    %formulation 4
    %f = f - spm_g*pre_voltage;
    %v = pre_voltage + C\(step_size/2*f);
    %[Ctmp Gtmp v_tmp alpha] = ConstructOneMEXP(C, Gl, B, v, step_size, input, pre_input);
    
    %formulation 5      
    v = pre_voltage;
    f = (dummy - spm_g*pre_voltage - (spm_c)*pre_voltage/step_size);
    pre_f = f;
    alpha = step_size/10;
    [Ctmp Gtmp v_tmp] = ConstructOneMEXP(C, SimParam.Gl, SimParam.B, v, step_size, alpha, ...
                                         input, pre_input, pre_f, f);
    
    %calulate the result of linear part
    T = Ctmp\Gtmp*(step_size/alpha);
    tmp_f = EXP0(T, v_tmp); 
    voltage = tmp_f(1:size(C, 1));
    
    %calculate the result of nonlinear part by NR method
    %'it' starts from 2 for avoiding state transition
    for it = 2:SimParam.max_iter
        % 0 is initial value for gnd; should always be 0
        [spm_c spm_g dummy f] = BSIM3Eval( SimParam.instance, [0; voltage], step_size, 'tran', first_time, it);
        first_time = 0; %set first_time as 0 after caling BSIM3Eval
        
        %Cnl = (SimParam.Cl + spm_c);
        %Gnl = (SimParam.Gl + spm_g);

        %formulation 1
        %x = L + C\(step_size/2*f);
        
        %formulation 2
        %x = L + EXP1(-(Cnl\Gnl)*step_size, Cnl\(f*step_size/2));
        
        %formulation 3
        %x = L + EXP1(-(Cnl\(Gl+rG))*step_size, (Cnl)\((f - spm_g * voltage)*step_size)/2);
        
        %formulation 4
        %f = f - spm_g*voltage;
        %x = L + Cnl\(step_size/2*f);        
        %dx = x - voltage;

        v = pre_voltage;
        f = (dummy - spm_g*voltage - (spm_c)*pre_voltage/step_size);
        
        alpha = step_size/10;
        [Ctmp Gtmp v_tmp] = ConstructOneMEXP(C, SimParam.Gl, SimParam.B, v, step_size, alpha, ...
                                             input, pre_input, pre_f, f);

        %calulate the result of linear part
        T = Ctmp\Gtmp*(step_size/alpha);
        tmp_f = EXP0(T, v_tmp); 
        x = tmp_f(1:size(C, 1));
        
        dx = x - voltage;
        
        if (norm(dx, 1) < SimParam.iter_err_tol)
            tot_it = it;
            converged = 1;
            voltage = x;
            break;
        end
        
        %update voltage with new solution x
        %voltage = voltage + dx;
        voltage = x;
    end
    if (converged ~= 1)
        converged
    end
    result = voltage;
    
end
