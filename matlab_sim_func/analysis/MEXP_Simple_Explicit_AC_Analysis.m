% Simple Explicit AC analysis for MEXP
% Inputs:
%   SimParam: simulation parameter structure
%   voltage: the voltaegs or currents values at current time step
%   input: input current/voltage sources 
%   pre_input: input current voltage sources at previous time step
%   step_size: time step size
%   first_time: first time for AC analysis
% Outputs:
%   result: the voltage at next_voltage
%   tot_it: total iteration
%   converged: 1 for converged, 0 for non converged
function [result tot_it converged dx] = MEXP_Simple_Explicit_AC_Analysis(SimParam, voltage, ...
                                                                         input, pre_input, step_size, first_time) 
    %perform AC analysis
    converged = 0;
    tot_it = 1;

    %calculate the linear terms (see TCAD/ICCAD paper)
    %get nonlineaer C G f_mexp in the previous state
    %'it' is set as 1 for internal state transition
    [spm_c spm_g dummy f] = BSIM3Eval( SimParam.instance, [0; voltage], step_size, 'tran', first_time, 1);
    first_time = 0; %set first_time as 0 after caling BSIM3Eval
    
    C = SimParam.Cl + spm_c; %assume nonlinear C spm_c varies mildly within this step
    G = SimParam.Gl + spm_g;

    %TODO
    %check regularization(?)

    %construct one exponential formular 
    v = voltage;    
    %alpha = step_size/10;
    alpha = 1;
    [Ctmp Gtmp v_tmp] = ConstructOneMEXP(C, G, SimParam.B, v, step_size, alpha, input, pre_input, f);
   
    %exponential by Krylov subspace
    [H V beta m] = krylov(Gtmp, Ctmp, step_size/alpha, v_tmp, 25);
    expH = EXP0(H(1:m, 1:m), eye(m, 1));
    %err = beta*H(m+1,m)*abs(expH(m,1));
    tmp_f = beta*V(:, 1:m)*expH;

    %easy way to calculate exponential 
    %T = Ctmp\Gtmp*(step_size/alpha);
    %tmp_f = EXP0(T, v_tmp);
    
    %TODO:
    %error check & step size shrink
     
    %update
    %'it' is set as other than 1 for avoiding internal state transition
    next_voltage = tmp_f(1:SimParam.max_node_num);
    [spm_c spm_g dummy f] = BSIM3Eval( SimParam.instance, [0; next_voltage], step_size, 'tran', first_time, 5);
    first_time = 0; %set first_time as 0 after caling BSIM3Eval

    Cnl = SimParam.Cl + spm_c; %assume nonlinear C spm_c varies mildly within this step
    Gnl = SimParam.Gl + spm_g;

    %calculate residual, Bu - (C dot_x + Gx)
    dxdt = Cnl\(-Gnl*next_voltage + SimParam.B*input+f);
    dx = (SimParam.B*input+f) - C*dxdt - G*next_voltage;    
    
    result = next_voltage;
end
