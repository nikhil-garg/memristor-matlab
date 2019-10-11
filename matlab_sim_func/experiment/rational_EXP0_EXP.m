%Caluate x = e^A*v in rational way
% Inputs:
%   A: input matrix
%   v: input vector
% Outputs:
%   result: e^A*v
function [result er] = rational_EXP0_EXP(A, v, scale)
    
    M = size(A, 1);
    
    %precondition 1
    %T = (eye(M, M) - A^-1)*scale;

    %precodition 2
    T = A^-1*scale;
    
    result = expm(T)*v;
    er = result(M,1);
end
