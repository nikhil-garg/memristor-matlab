%Caluate x = e^A*v
% Inputs:
%   A: input matrix
%   v: input vector
% Outputs:
%   result: e^A*v
function result = EXP0(A, v)
    
    result = expm(A)*v;
end
