function [Gl Cl pins nins max_node_num] = load_pdn_case
    
    load '../pdn_cases_from_xiang/pdn_case1_30K.mat';
    %load '../netlist/rc_50.mat';

    %load '../netlist/rc_10.mat';
    %G = -A;
    
    Cl = C;
    Gl = G;

    pins = [];
    nins = [];

    max_node_num = size(Gl, 1);

end
