%simulate IBM PG benchmark using TR method
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

sim_param.step_size = 10*10^-12; %1ps
sim_param.end_time = 1*10^-8;
time = 0:sim_param.step_size:sim_param.end_time; %0~10ns

testcase_dir = '../ibm_pg_benchmark/ibmpg1t/';
%load ibm pg benchmark
[sim_param.Gl sim_param.Cl sim_param.pins sim_param.nins sim_param.max_node_num] = load_ibmpdn_case([testcase_dir]);
[Bi sim_param.InputSrcs] = LoadPulseInputFile([testcase_dir, 'Isrc.dat'], sim_param.max_node_num);
[Bv sim_param.VoltageSrcs] = LoadVoltageInputFile([testcase_dir, 'Vsrc.dat'], sim_param.max_node_num);
D = LoadOutputNodeFile([testcase_dir, 'OutputNode.dat'], sim_param.max_node_num);
sim_param.B = [Bi, Bv];

%initial voltage are at zero
[input max_step_size] = ComputePulseInputs(sim_param, 0, 0);

%load PDN cases
%testcase_dir = '../pdn_cases/pdn_case1_30K/';
%[sim_param.Gl sim_param.Cl sim_param.pins sim_param.nins sim_param.max_node_num] = load_ibmpdn_case([testcase_dir]);
%[Bi sim_param.InputSrcs] = LoadInputFile([testcase_dir, 'step_input.dat'], sim_param.max_node_num);
%[Bv sim_param.VoltageSrcs] = LoadVoltageInputFile([testcase_dir, 'Vsrc.dat'], sim_param.max_node_num);
%sim_param.B = [Bi, Bv];
%[input] = ComputePWLInputs(sim_param, 0, 0);


elapse = tic;
voltage = (sim_param.Gl)\(sim_param.B*[input;sim_param.VoltageSrcs]);
runtime_dc = toc(elapse);
display(['runtime of dc analysis: ', num2str(runtime_dc)]);

result = zeros(size(D, 1), size(time, 2));

%DC Analysis
%observed_node = 114488;
%observed_node = 3902; %for ibmpg1t
%observed_node = 386534; %for ibmpg3t
%observed_node = 1154987; %for ibmpg4t
%observed_node = 761975; %for ibmpg5t
%observed_node = 971956; %for ibmpg6t
%observed_node = 15230;

result(:, 1) = D*voltage;
pre_voltage = voltage;

%LU decomposition
elapse = tic;
[L U P Q] = lu((2*sim_param.Cl/sim_param.step_size + sim_param.Gl));
runtime_lu = toc(elapse);
display(['runtime of LU decomposition:', num2str(runtime_lu)]);

total_m = 0;
%transient analysis
elapse = tic;
for i = 2:size(time, 2)

    current_time = time(i-1);
    step_size = sim_param.step_size;
    
    %read the input for next time step
    pre_input = input;
    [input max_step_size] = ComputePulseInputs( sim_param, current_time, step_size);
    %[input max_step_size] = ComputePWLInputs( sim_param, current_time, step_size);
    if (step_size - max_step_size > step_size/10000)
        error(['should use smaller step size: ', num2str(max_step_size)]);
    end
    %construct one exponential formular
    b = (2*sim_param.Cl/step_size-sim_param.Gl)*pre_voltage + sim_param.B*[input; sim_param.VoltageSrcs] + sim_param.B*[pre_input; sim_param.VoltageSrcs];
    voltage = Q*(U\(L\(P*b)));
    %voltage = (Cl/step_size + Gl)\(Cl/step_size*pre_voltage + B*input);
    total_m = total_m + 1;
    %update previous time step and save the result
    pre_voltage = voltage;

    result(:, i) = D*voltage;
end
runtime_transient = toc(elapse);
display(['runtime of transient:', num2str(runtime_transient)]);
display(['total backward/forward substitution:', num2str(total_m)]);
