%simulate a simple inverter using BE method

%add mex & matlab function path
addpath([pwd, '/../../../mex']);
addpath([pwd, '/../../../matlab_sim_func']);
addpath([pwd, '/../../../matlab_sim_func/model_level1']);
addpath([pwd, '/../../../matlab_sim_func/kernels']);
addpath([pwd, '/../../../matlab_sim_func/analysis']);
addpath([pwd, '/../../../matlab_sim_func/utils']);

%create empty simulation parameter structure
[sim_param] = CreateSimStruct;

%simulation setting
sim_param.max_iter = 100;
sim_param.err_tol = 1e-5;
sim_param.step_size = 1*10^-12; %1ps
sim_param.end_time = 1*10^-9;
time = 0:sim_param.step_size:sim_param.end_time; %0~1ns

%load inverter circuit
[sim_param.Gl sim_param.Cl sim_param.pins sim_param.nins sim_param.max_node_num] = load_inv_chain_ckt_mexp_r_load_case;
[sim_param.B sim_param.InputSrcs] = LoadInputFile('inputs.dat', sim_param.max_node_num);

%load model card
[sim_param.model_card] = LoadBSIM3Model('tsmc90.spice3');

%show up the loaded model card name
[sim_param.instance] = LoadBSIM3Instance( sim_param.pins, sim_param.nins, sim_param.model_card, ...
                                          'pch1', 'nch1', sim_param.max_node_num, 27.00);

[input] = ComputePWLInputs(sim_param, 0, 0);
voltage = zeros(sim_param.max_node_num, 1);



%call DC analysis 
[x tot_it converged pre_f] = DC_Analysis(sim_param, voltage, input);

result = zeros(sim_param.max_node_num, size(time, 2));
error = zeros(1, size(time, 2));

step_size = sim_param.step_size;
pre_voltage = x;
result(:,1) = x;
first_time = 1;
%transient analysis
for i = 2:size(time, 2)
    %prediction for the next time step initial voltage
    voltage = pre_voltage;
    current_time = time(i-1);
    
    %read the input for next time step
    [input max_step_size] = ComputePWLInputs(sim_param, current_time, step_size);
    
    %perform NR iteration in backward Euler method
    [voltage] = BE_NR_AC_Analysis(sim_param, voltage, pre_voltage, input, ...
                                  step_size, first_time);

    %TODO:
    %check the convergence

    %update previous time step and save the result
    pre_voltage = voltage;
    result(:,i) = voltage;
end
