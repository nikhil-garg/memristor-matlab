% Load mose file
% Inputs:
% Outputs:
%   nins: instances of nmos
%   pins: instances of pmos
function [nins pins] = LoadMosFile(filename)
    fprintf('loading mosfet file %s\n', filename);

    rawfile = load(filename);

    %in mos.dat
    %-1 indicates pmos; 1 indicates nmos
    pmos_idx = find(rawfile(:,1) == -1); 
    nmos_idx = find(rawfile(:,1) == 1);
    
    pins = rawfile(pmos_idx, 2:end);
    nins = rawfile(nmos_idx, 2:end);
end
