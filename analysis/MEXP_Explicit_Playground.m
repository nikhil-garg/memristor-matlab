% Simple Explicit AC analysis test field
% Inputs:
%   SimParam: simulation parameter structure
%   ptr_instance: the pointer to the BSIM3 instances in the circuit
%   voltage: the voltaegs or currents values at previous time step
%   input: input current/voltage sources 
%   pre_input: input current voltage sources at previous time step
%   step_size: time step size
%   first_time: first time for AC analysis
% Outputs:
%   result: the voltage/current at next time step
%   tot_it: total iteration
%   converged: 1 for converged, 0 for non converged
function [result tot_it converged f_dx] = MEXP_Explicit_Playground(SimParam, voltage, ...
                                                                   input, pre_input, step_size, first_time)
   
    %perform AC analysis
    converged = 0;
    tot_it = 1;

    %calculate the linear terms (see TCAD/ICCAD paper)
    %get nonlineaer C G f_mexp in the previous state
    [spm_c spm_g dummy f_old] = BSIM3Eval( SimParam.instance, [0; voltage], step_size, 'tran', first_time, 5);
    first_time = 0; %set first_time as 0 after caling BSIM3Eval

    C = SimParam.Cl + spm_c; %assume nonlinear C spm_c varies mildly within this step
    G = SimParam.Gl + spm_g;
    Cold = C;
    Gold = G;
    %TODO
    %check regularization(?)

    %residual compensate
    dx = zeros(SimParam.max_node_num, 1);
    f = f_old;
    f_dx = dx;
    v_old = voltage;
    for i = 1:SimParam.max_iter
        %construct one exponential formular 
        %v = voltage;       
        alpha = step_size/10;
        [Ctmp Gtmp v_tmp] = ConstructOneMEXP(Cold, Gold, SimParam.B, voltage, step_size, alpha, input, pre_input, f_old, f, f_dx);
    
        %exponential by Krylov subspace
        [H V beta m] = krylov(Gtmp, Ctmp, step_size/alpha, v_tmp, 10);
        expH = EXP0(H(1:m, 1:m), eye(m, 1));
        err = beta*H(m+1,m)*abs(expH(m,1));
        tmp_f = beta*V(:, 1:m)*expH;
    
        %easy way to calculate exponential 
        %T = Ctmp\Gtmp*(step_size/alpha);
        %tmp_f = EXP0(T, v_tmp);
        
        %TODO:
        %error check & step size shrink

        %update
        next_voltage = tmp_f(1:SimParam.max_node_num);

        %residue by xn
        %calculate residual, Bu+f - (C dot_x + Gx)
        %dx = (B*input+f_old) - Cold*dxdt - Gold*next_voltage;
        
        [spm_c spm_g dummy f] = BSIM3Eval( SimParam.instance, [0; next_voltage], step_size, 'tran', first_time, 5);
        first_time = 0; %set first_time as 0 after caling BSIM3Eval

        C = SimParam.Cl + spm_c; %assume nonlinear C spm_c varies mildly within this step
        G = SimParam.Gl + spm_g;
        
        dxdt = Cold\(-Gold*next_voltage + SimParam.B*pre_input+f);
        
        %residue by xn+1        
        %ndxdt = C\(-G*next_voltage + B*input+f);
        %dx = (B*input+f) - C*ndxdt - G*next_voltage - dx;
        
        %dx = (f-f_old) - (C - Cold)*ndxdt - (G-Gold)*next_voltage;
        %mexp residue        
        f_dx = (B*input+f) - C*dxdt - G*next_voltage     
        
        if (norm(f_dx, 'inf') <= SimParam.iter_err_tol)
            converged = 1;
            tot_it = i;            
            break;
        end       
    end 
    if (converged == 0)
        f_dx
    end
    result = next_voltage;
end
