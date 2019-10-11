%Construct One-MEXP formulation from LU (reduced version)
% Inputs:
%   B: B matrix
%   step_size: time step 
%   alpha: scalar for numerical stability (should always be 1 for rational
%          Krylov space)
%   input:  input voltage & current sources
%   pre_input: input voltage & current sources at previous time step
%   (optional) pre_f: equivalent current sources from transistors at previous time step
%   (optional) f: equivalent current sources from transistors at current time step
% Outputs:
%   W: W matrix
%   Ij: I+J matrix
function [W Ij vtmp ep] = ConstructOneMEXP_LU( B, v, step_size, alpha, input, pre_input, pre_f, f)
    
    total_params = 6;

    N = size(B, 1); 
    if (nargin == total_params)
        f = zeros(N, 1);
        pre_f = zeros(N, 1);
    elseif (nargin == total_params+1)
        f = pre_f;
    end

    cur_inputs = B*input;
    prev_inputs = B*pre_input;

    du = (cur_inputs - prev_inputs)/step_size + (f - pre_f)/step_size;

    Ij = speye(2, 2)/step_size - sparse([0, alpha; 0, 0]);
    W = [du, prev_inputs+pre_f];

    if (norm(W,1) ~= 0 && norm(W, 1) ~= 1) %not sure...
        eta = 2^(-ceil(log2(norm(W, 1))));
        %eta = 1;
    else
        eta = 1;
    end
    ep = (eta^-1) * sparse([0; 1]);
    W = -eta*W;
    vtmp = [v; ep];
end
