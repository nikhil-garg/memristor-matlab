% Load voltage inputs file
% Inputs:
% Outputs:
function [B VoltageInputSrcs] = LoadVoltageInputFile(filename, max_node_num)
    
    fprintf('loading voltage input file %s\n', filename);

    rawfile = load(filename);
    
    num_sources = size(rawfile, 1);
    B = sparse(max_node_num, num_sources);

    for i = 1:num_sources
        x = rawfile(i, 1);
        B( x, i) = -1;
    end

    VoltageInputSrcs = rawfile(:, 2:end);
end
