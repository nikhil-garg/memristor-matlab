% Load pulse inputs file
% Inputs:
% Outputs:
function [B PulseInputSrcs] = LoadPulseInputFile(filename, max_node_num)
    
    fprintf('loading pulse input file %s\n', filename);

    rawfile = load(filename);
    
    num_sources = size(rawfile, 1);
    B = sparse(max_node_num, num_sources);

    for i = 1:num_sources
        x = rawfile(i, 1);
        y = rawfile(i, 2);
        
        if (x ~= 0)
            B( x, i) = -1;
        end
        
        if (y ~= 0)
            B( y, i) = 1;
        end
    end

    PulseInputSrcs = rawfile(:, 3:end);
end
