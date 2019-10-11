function [Gl Cl pins nins max_node_num] = load_interconnect_ckt
    
    pins = [];
    nins = [];

    R1 = 1e-2;
    C1 = 1e-15;
    L1 = 1e-12;
    Rv = 1;

    Gl = [ 1/Rv 0   0	0   1	0   0
	    0	0   0	0   -1	1   0
	    0	0   0	0   0	-1  1
	    0	0   0  1/Rv 0	0  -1 
	    -1	1   0	0   R1	0   0	
	    0	-1  1	0   0	R1  0	
	    0	0   -1	1   0	0   R1];

    Cl = [C1	0   0	0   0	0   0
	    0	C1  0	0   0	0   0
	    0	0   C1	0   0	0   0
	    0	0   0	C1  0	0   0	
	    0	0   0	0   L1	0   0	
	    0	0   0	0   0	L1  0	
	    0	0   0	0   0	0   L1];
    
    max_node_num = size(Gl, 1);
end
