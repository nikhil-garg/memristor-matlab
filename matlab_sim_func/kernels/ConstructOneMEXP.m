%Construct One-MEXP formulation
% Inputs:
%   C: matrix C
%   G: matrix G
%   B: matrix B
%   v: input vector
%   step_size: time step 
%   alpha: scalar for numerical stability (should always be 1 for rational
%          Krylov space)
%   input:  input voltage & current sources
%   pre_input: input voltage & current sources at previous time step
%   (optional) pre_f: equivalent current sources from transistors at previous time step
%   (optional) f: equivalent current sources from transistors at current time step
% Outputs:
%   Ctmp: Composed C for one-mexp formular
%   Gtmp: Composed G for one-mexp formular
%   vtmp: Composed input vector for one-mexp formular
function [Ctmp Gtmp vtmp] = ConstructOneMEXP(C, G, B, v, step_size, alpha, input, pre_input, pre_f, f)
    
    total_params = 8;

    N = size(C, 1);
    if (nargin == total_params)
        f = zeros(N, 1);
        pre_f = zeros(N, 1);
    elseif (nargin == total_params+1)
        f = pre_f;
    end

    cur_inputs = B*input;
    prev_inputs = B*pre_input;

    Ctmp = [C/alpha, sparse(N, 2);
            sparse(2, N), speye(2)];
    du = (cur_inputs - prev_inputs)/step_size + (f - pre_f)/step_size;

    J = sparse([0, alpha; 0, 0]);
    W = [du, prev_inputs+pre_f];

    if (norm(W,1) ~= 0 && norm(W, 1) ~= 1) %not sure...
        eta = 2^(-ceil(log2(norm(W, 1))));        
    else
        eta = 1;
    end
    %eta = 1;
    
    ep = sparse([0; 1]);
    Gtmp = [-G, eta * W;
            sparse(2, N), J];

    vtmp = [v; (eta^-1)*ep];
end
