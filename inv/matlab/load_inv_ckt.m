function [Gl Cl pins nins max_node_num] = load_inv_ckt

    %D G S B Level(unused) W L VT0(unused) lambda(unused) KP(unused)
    pins = [2 1 3 3 1 2e-6 100e-9 1 1 1]; %w=2u l=100nm
    nins = [2 1 0 0 1 1e-6 100e-9 1 1 1]; %w=1u l=100nm
    
    %R & C values
    R1 = 0.01;  %10m
    C1 = 1e-15; %1fF
    Rv = 1; 
    
    %linear G & C
    Gl = [1/R1  0	  0	0	-1/R1
          0	    1/R1  0	-1/R1	0
          0	    0	  1/Rv	0	0
          0	    -1/R1 0	1/R1	0
          -1/R1 0	  0	0	1/Rv+1/R1]; 
    
    %for BE case (all grounded cap)
    Cl = [0 0 0 0 0
          0 0 0 0 0
          0 0 0 0 0
          0 0 0 C1 0
          0 0 0 0 0];
    
    B = [0 0
         0 0
         1 0
         0 0
         0 1];

    max_node_num = size(Gl, 1);
end
