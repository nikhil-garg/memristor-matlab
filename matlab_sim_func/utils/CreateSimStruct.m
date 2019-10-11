% Create Simulation Parameter Struct
% Inputs:
% Output:
%   Simulation struct
function [sim_struct] = CreateSimStruct
    
    %Simulation struct
    %matrices Gl, Cl, B
    sim_struct.Cl = [];
    sim_struct.Gl = [];
    sim_struct.B = [];

    %%matrices of LU factorization
    %sim_struct.L = [];
    %sim_struct.U = [];
    %sim_struct.P = [];
    %sim_struct.Q = [];

    %simulation input sources
    sim_struct.InputSrcs = [];

    %simulation voltage sources
    sim_struct.VoltageSrcs = [];

    %pointer to the model card
    sim_struct.model_card = 0;

    %PMOS in SMORES format
    sim_struct.pins = [];

    %NMOS in SMORES format
    sim_struct.nins = [];

    %pointer to instance of device
    sim_struct.instance = 0;

    %maximum node number
    sim_struct.max_node_num = 0;

    %default step size
    sim_struct.step_size = 0;

    %simulation end time
    sim_struct.end_time = 0;

    %maximum iteration number
    sim_struct.max_iter = 0;
    
    %total error during simulation 
    sim_struct.err_tol = 0;

    %error tolerance during iteration for NR or fixed pt method
    sim_struct.iter_err_tol = 0;

    %gamma for rational krylov subspace
    sim_struct.gamma = 0;

    %maximum allowed dimension m for rational krylov subspace
    sim_struct.rational_max_m = 0;

    %induced currents and charges in nonlinear devices at current time
    sim_struct.f = 0;
    
    %induced currents and charges in nonlinear devices at previous time 
    sim_struct.pre_f = 0;
    
    %derivative of induced currents and charges in nonlinear devices at
    %previous time
    sim_struct.pre_dfdt = 0;

    %derivative of nodal voltages and branch currents at previous time
    sim_struct.pre_dxdt = 0;
end
