%simulating IBM PG benchmark cases in BE
clear all;

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
sim_param.end_time = 10*10^-9;
time = 0:sim_param.step_size:sim_param.end_time; %0~10ns

testcase_dir = '../ibm_pg_benchmark/ibmpg1t/';
%load power grid
[sim_param.Gl sim_param.Cl sim_param.pins sim_param.nins sim_param.max_node_num] = load_ibmpdn_case([testcase_dir]);
%[B InputSrcs] = LoadInputFile('inputs.dat', max_node_num);
[Bi sim_param.InputSrcs] = LoadPulseInputFile([testcase_dir, 'Isrc.dat'], sim_param.max_node_num);
[Bv sim_param.VoltageSrcs] = LoadVoltageInputFile([testcase_dir, 'Vsrc.dat'], sim_param.max_node_num);
sim_param.B = [Bi, Bv];

%initial voltage are at zero
[input max_step_size] = ComputePulseInputs(sim_param, 0, 0);
voltage = zeros(sim_param.max_node_num, 1);

voltage = (sim_param.Gl)\(sim_param.B*[input; sim_param.VoltageSrcs]);
result = zeros(6, size(time, 2));
%error = zeros(1, size(time, 2));

%DC Analysis

%initial global var - states of f (nonlinear C & G & Ids)
result(1:5,1) = voltage(1:5);
result(6,1) = voltage(17346);
pre_voltage = voltage;
step_size = sim_param.step_size;

%LU decomposition
tic;
[L U P Q] = lu((sim_param.Cl/step_size + sim_param.Gl));

%transient analysis
for i = 2:size(time, 2)

    current_time = time(i-1);

    %read the input for next time step
    pre_input = input;
    [input max_step_size] = ComputePulseInputs(sim_param, current_time, step_size);
    if (step_size - max_step_size > step_size/10000)
        error(['should use smaller step size: ', num2str(max_step_size)]);
    end
    %construct one exponential formular
    b = (sim_param.Cl/step_size*pre_voltage + sim_param.B*[input; sim_param.VoltageSrcs]);
    voltage = Q*(U\(L\(P*b)));
    %voltage = (Cl/step_size + Gl)\(Cl/step_size*pre_voltage + B*input);
    
    %update previous time step and save the result
    pre_voltage = voltage;
    result(1:5,i) = voltage(1:5);
    result(6,i) = voltage(17346);
end
toc