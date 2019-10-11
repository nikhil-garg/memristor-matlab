%Construct One-MEXP formulation from LU (DEPRECATE)
% Inputs:
%   L: L matrix for C/h+G
%   U: U matrix for C/h+G
%   P: P matrix for C/h+G
%   Q: Q matrix for C/h+G
%   C: C matrix
%   B: B matrix 
%   v: input vector
%   step_size: time step 
%   alpha: scalar for numerical stability (should always be 1 for rational
%          Krylov space)
%   input:  input voltage & current sources
%   pre_input: input voltage & current sources at previous time step
%   (optional) pre_f: equivalent current sources from transistors at previous time step
%   (optional) f: equivalent current sources from transistors at current time step
% Outputs:
%   Ltmp: Composed L for one-mexp formular
%   Utmp: Composed U for one-mexp formular
%   Ptmp: Composed P for one-mexp formular
%   Qtmp: Composed Q for one-mexp formular
%   Ctmp: Composed C for one-mexp formular
%   vtmp: Composed input vector for one-mexp formular
function [Ltmp Utmp Ptmp Qtmp Ctmp vtmp] = ConstructOneMEXP_LU_Unused(L, U, P, Q, C, B, v, step_size, alpha, input, pre_input, pre_f, f)
    
    error('this version is obsolete');

    total_params = 11;

    N = size(L, 1);
    if (nargin == total_params)
        f = zeros(N, 1);
        pre_f = zeros(N, 1);
    elseif (nargin == total_params+1)
        f = pre_f;
    end

    cur_inputs = B*input;
    prev_inputs = B*pre_input;

    du = (cur_inputs - prev_inputs)/step_size + (f - pre_f)/step_size;

    J = sparse([0, alpha; 0, 0]);
    W = [du, prev_inputs+pre_f];
    %J = sparse([0, 0; 0, 0]);
    %W = [(prev_inputs+pre_f), du];

    if (norm(W,1) ~= 0 && norm(W, 1) ~= 1) %not sure...
        eta = 2^(-ceil(log2(norm(W, 1))));
        %eta = 1;
    else
        eta = 1;
    end
    
    Ctmp = [C/alpha, sparse(N, 2);
            sparse(2, N), speye(2)];
    Ltmp = [L, sparse(N, 2);
            sparse(2, N), speye(2)];

    Utmp = [U, L\(-P*eta*W);
            sparse(2,N), speye(2)/step_size-J];

    Ptmp = [P, sparse(N, 2);
            sparse(2, N), speye(2)];
    
    Qtmp = [Q, sparse(N, 2);
            sparse(2, N), speye(2)];

    ep = sparse([0; 1]);
    vtmp = [v; (eta^-1)*ep];
end
