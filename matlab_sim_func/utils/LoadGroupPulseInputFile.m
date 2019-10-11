% Load pulse inputs file in grpu
% Inputs: 
%   filename: for Isrc_config.dat, which indicates how 
%	      many groups and required time instants
%   prefix: prefix string of each group sources
%   max_node_num: maximum number of nodes in the circuit
% Outputs:
%   B:	cells for B matrices for grouped current sources
%   PulseInputSrcs: cells for grouped current sources
function [B PulseInputSrcs] = LoadGroupPulseInputFile(filename, prefix_name, max_node_num)
    
    fprintf('loading pulse input configuration file %s\n', filename);

    rawfile = load(filename);

    num_groups = rawfile(1);
    
    B = cell(num_groups, 1);
    PulseInputSrcs = cell(num_groups, 1);
    
    for k = 1:num_groups
        groupfilename = [prefix_name, num2str(k-1), '.dat'];
        rawfile = load(groupfilename);

        num_sources = size(rawfile, 1);
    	tmpB = sparse(max_node_num, num_sources);

    	for i = 1:num_sources
    	    x = rawfile(i, 1);
    	    y = rawfile(i, 2);
    	    
    	    if (x ~= 0)
    	        tmpB( x, i) = -1;
    	    end
    	    
    	    if (y ~= 0)
    	        tmpB( y, i) = 1;
    	    end
        end

        B{k} = tmpB;
    	PulseInputSrcs{k} = rawfile(:, 3:end);
    end
end
