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
function [H V beta m] = rational_krylov_inverted_only(G, C, h, v, m)

    N = size(G,2);
    V = zeros(N, m+1);
    H = zeros(m+1,m);

    beta = norm(v, 2);
    if (beta == 0)
        return;
    end

    V(:,1) = v / beta;

    for j = 1:m
        %precondition 1
        %w = (C+h*G)\((C-h*G)*V(:,j)); %solve Cx = Av
        
        %precondition 2
        %w = (C/h-G)\(C/h*V(:,j)); %solve Cx = Av
	w = (h*G)\(C*V(:,j));
        for reoth = 1:1
            for i = 1:j 
                ip = w'*V(:,i);
                H(i,j) = H(i,j) + ip;
                w = w - ip*V(:,i);
            end
        end
        H(j+1, j) = norm(w, 2);       
        if H(j+1,j) < j*eps
            m = j; 
            H = H(1:m+1,1:m); V = V(:,1:m+1);
            return; 
        end
        V(:,j+1) = w/H(j+1,j);   
    end
    
end