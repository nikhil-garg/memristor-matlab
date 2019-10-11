%simulate power grid case using MEXP method

clear all;
%add mex & matlab function path
addpath([pwd, '/../../../mex']);
addpath([pwd, '/../../../matlab_sim_func']);
addpath([pwd, '/../../../matlab_sim_func/model_level1']);
addpath([pwd, '/../../../matlab_sim_func/kernels']);
addpath([pwd, '/../../../matlab_sim_func/analysis']);
addpath([pwd, '/../../../matlab_sim_func/utils']);
addpath([pwd, '/../../../matlab_sim_func/experiment']);

%create empty simulation parameter structure
[sim_param] = CreateSimStruct;

%simulation setting
sim_param.max_iter = 100;
sim_param.iter_err_tol = 1e-5;
sim_param.err_tol = 1e-4;
sim_param.rational_max_m = 40;

sim_param.step_size = 1000*10^-12; %1ps
sim_param.gamma = 100*10^-12;
sim_param.end_time = 1*10^-8;
time = 0:sim_param.step_size:sim_param.end_time; %0~1ns

testcase_dir = '../ibm_pg_benchmark/ibmpg1t/';
%load ibmbenchmark power grid case
[sim_param.Gl sim_param.Cl sim_param.pins sim_param.nins sim_param.max_node_num] = load_ibmpdn_case([testcase_dir]);
[Bi sim_param.InputSrcs] = LoadPulseInputFile([testcase_dir, 'Isrc.dat'], sim_param.max_node_num);
[Bv sim_param.VoltageSrcs] = LoadVoltageInputFile([testcase_dir, 'Vsrc.dat'], sim_param.max_node_num);
D = LoadOutputNodeFile([testcase_dir, 'OutputNode.dat'], sim_param.max_node_num);
sim_param.B = [Bi, Bv];
[input max_step_size] = ComputePulseInputs( sim_param, 0, 0);

%load PDN cases
%testcase_dir = '../pdn_cases/pdn_case1_30K/';
%[sim_param.Gl sim_param.Cl sim_param.pins sim_param.nins sim_param.max_node_num] = load_ibmpdn_case([testcase_dir]);
%[Bi sim_param.InputSrcs] = LoadInputFile([testcase_dir, 'step_input.dat'], sim_param.max_node_num);
%[Bv sim_param.VoltageSrcs] = LoadVoltageInputFile([testcase_dir, 'Vsrc.dat'], sim_param.max_node_num);
%sim_param.B = [Bi, Bv];
%[input] = ComputePWLInputs(sim_param, 0, 0);

elapse = tic;
voltage = sim_param.Gl\(sim_param.B*[input; sim_param.VoltageSrcs]);
runtime_dc = toc(elapse);
display(['runtime of dc anaysis:', num2str(runtime_dc)]);
error = zeros(1, size(time, 2));

%for IBM PG benchmark
%observed_node = 114488;
%observed_node = 3902; %for ibmpg1t
%observed_node = 386534; %for ibmpg3t
%observed_node = 1154987; %for ibmpg4t
%observed_node = 761975; %for ibmpg5t
%observed_node = 971956; %for ibmpg6t

%for PDN cases
observed_node = 15230; %for step input

%initial global var - states of f (nonlinear C & G & Ids)
result = zeros(size(D, 1), size(time, 2));

result(:, 1) = D*voltage;
pre_voltage = voltage;
step_size = sim_param.step_size;
alpha = 1;

CurInput = [input; sim_param.VoltageSrcs];

current_time = 0;
time_idx = 1;
time(time_idx) = current_time;
elapse = tic;
[L U P Q] = lu((sim_param.Cl/sim_param.gamma + sim_param.Gl));
%[L U P Q] = lu(-sim_param.Gl);
runtime_lu = toc(elapse);
display(['runtime of LU decomposition:', num2str(runtime_lu)]);

%save ibmpg4t_LU_result.mat;
%load ibmpg4t_LU_result.mat;
%order_m = 10;
total_m = 0;
elapse = tic;
while current_time < sim_param.end_time    
    
    %prediction for the next time step initial voltage
    voltage = pre_voltage;
    
    %read the input for next time step
    PreInput = CurInput;
        
    [input max_step_size] = ComputePulseInputs( sim_param, current_time, step_size);
    %[input max_step_size] = ComputePWLInputs( sim_param, current_time, step_size);
    CurInput = [input; sim_param.VoltageSrcs];

    if (step_size >= max_step_size)
        scale = max_step_size/sim_param.gamma;
    else
        scale = step_size/sim_param.gamma;
    end

    %construct one exp    
    [W Ij vtmp ep] = ConstructOneMEXP_LU(sim_param.B, voltage, sim_param.gamma, alpha, PreInput + (CurInput-PreInput)/max_step_size*sim_param.gamma, PreInput);  
    
    [H V beta m expH er] = Adaptive_Rational_Krylov_LU( sim_param, L, U, P, Q, sim_param.Cl, W, Ij, ep, sim_param.gamma/alpha, vtmp, scale);
    
    tmp_f = beta*V(:,1:m)*expH;
    
    voltage = tmp_f(1:sim_param.max_node_num);
    %voltage = beta*V(:,1:m)*expH;
    total_m = total_m + m;
    
    %update previous time step and save the result
    pre_voltage = voltage;
    time_idx = time_idx + 1;
    current_time = current_time + max_step_size;
    %display(['current time: ', num2str(current_time)]);
    result(:, time_idx) = D*voltage;
    time(time_idx) = current_time;
    used_m(time_idx) = m;
end
runtime_mexp = toc(elapse);
display(['runtime of MEXP:', num2str(runtime_mexp)]);
display(['total backward/forward substitution:', num2str(total_m)]);
