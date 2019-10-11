% ETD2RK Explicit AC analysis for MEXP
% Inputs:
%   SimParam: simulation parameter structure
%   ptr_instance: the pointer to the BSIM3 instances in the circuit
%   voltage: the voltages or currents values at current time step
%   pre_f: the transistor current at previous time step
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
%   dx: residue
function [result tot_it converged dx] = MEXP_ETD2RK_Explicit_AC_Analysis(SimParam, voltage,  ...
                                                                       input, pre_input, step_size, first_time)
    %perform AC analysis
    converged = 0;
    tot_it = 1;

    %calculate f in current time step 
    %5 could be any number other than 1 and -1
    %get nonlineaer C G f_mexp in the previous state
    [spm_c spm_g dummy f] = BSIM3Eval( SimParam.instance, [0; voltage], step_size, 'tran', first_time, 5);
    first_time = 0; %set first_time as 0 after caling BSIM3Eval

    C = SimParam.Cl + spm_c; %assume nonlinear C spm_c varies mildly within this step
    G = SimParam.Gl + spm_g;

    %TODO
    %check regularization(?)

    %construct one exponential formular 
    v = voltage;    
    alpha = step_size/10;
    [Ctmp Gtmp v_tmp] = ConstructOneMEXP(C, G, SimParam.B, v, step_size, alpha, input, pre_input, f);

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

    %an for ETD2RK
    an = tmp_f(1:SimParam.max_node_num);
    [spm_c spm_g dummy cur_f] = BSIM3Eval( SimParam.instance, [0; an], step_size, 'tran', first_time, 5);

    %C = Cl + spm_c;
    %G = Gl + spm_g;
    
    %calculate the xn+1 using an and cur_f
    %v = zeros(size(voltage));       
    %t1 = zeros(size(input));
    %[Ctmp Gtmp v_tmp alpha] = ConstructOneMEXP(C, G, B, v, step_size, t1, t1, f, cur_f);

    %exponential by Krylov subspace
    %[H V beta m] = krylov(Gtmp, Ctmp, step_size/alpha, v_tmp, 10);
    %expH = EXP0(H(1:m, 1:m), eye(m, 1));
    %err = beta*H(m+1,m)*abs(expH(m,1));
    %tmp_f = beta*V(:, 1:m)*expH;
    L = EXP2(-C\G*step_size, (C\(cur_f-f))*step_size);

    %calculate f at an
     
    %update
    next_voltage = an + L; %tmp_f(1:size(C, 1));
    [spm_c spm_g dummy f] = BSIM3Eval( SimParam.instance, [0; next_voltage], step_size, 'tran', first_time, 5);
    first_time = 0; %set first_time as 0 after caling BSIM3Eval

    C = SimParam.Cl + spm_c; %assume nonlinear C spm_c varies mildly within this step
    G = SimParam.Gl + spm_g;

    %calculate residual, Bu - (C dot_x + Gx)
    dx = (SimParam.B*input+f) - C*(next_voltage - voltage)/step_size - G*next_voltage;

    result = next_voltage;
end
