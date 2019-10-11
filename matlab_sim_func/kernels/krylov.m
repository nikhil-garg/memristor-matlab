%Calculate Krylov subspace K = {A, v}
% Inputs:
%   G: G matrix
%   C: C matrix (note A = C^-1*G)
%   h: time step size
%   v: initial vector
%   m: dimension of the krylov subspace
% Output:
%   H: resulting Hessenberg matrix
%   V: orthonormal bases
%   beta: 2-norm of initial vector
function [H V beta m] = krylov(G, C, h, v, m)

    N = size(G,2);
    V = zeros(N, m+1);
    H = zeros(m+1,m);

    beta = norm(v, 2);
    if (beta == 0)
        return;
    end

    V(:,1) = v / beta;

    for j = 1:m-1
        w = ((C/h)\(G*V(:,j))); %solve Cx = Av
        for i = 1:j 
            H(i,j) = w'*V(:,i);
            w = w - H(i,j)*V(:,i);
        end
        H(j+1, j) = norm(w, 2);
        if H(j+1,j) == 0
            m = j; 
            H = H(1:m+1,1:m); V = V(:,1:m+1);
            return; 
        end
        V(:,j+1) = w/H(j+1,j);   
    end

    w = ((C/h)\(G*V(:,m)));
    for i = 1:m
        H(i,m) = w'*V(:,i);
        w = w - H(i,m)*V(:,i);
    end
    H(m+1, m) = norm(w, 2);
    V(:,m+1) = w/H(m+1,m);

end
