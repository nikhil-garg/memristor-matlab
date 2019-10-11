% Load output node file
% Inputs:
% Outputs:
function [D] = LoadOutputNodeFile(filename, max_node_num)
    
    
    if (exist(filename) == 0)
	fprintf('output node file %s does not exisit, will outupt all nodes', filename);
	D = speye(max_node_num, max_node_num);
    else
	fprintf('loading ouput node file %s\n', filename);
	rawfile = load(filename);

    	num_outputs = size(rawfile, 1);
    	D = sparse(num_outputs, max_node_num);

    	for i = 1:num_outputs
    	    D(i, rawfile(i)) = 1;
    	end
    end

end
