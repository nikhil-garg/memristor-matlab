% Adaptive Rational Krylov Subspace and eA Computation (DEPRECATE)
% Inputs:
%   L: L matrix
%   U: U matrix (note A = C^-1*G)
%   P: P matrix 
%   Q: Q matrix
%   h: time step size
%   v: initial vector
%   m: dimension of the krylov subspace
%   scale: the target scale 
%   err_tol: error tolerance
% Output:
%   H: resulting Hessenberg matrix
%   V: orthonormal bases
%   beta: 2-norm of initial vector
%   m: actually required m 
%   expH: result of e^(1-H^-1)*e1
%   err: estimation error 
function [H V beta m expH err] = Adaptive_Rational_Krylov_Unused(L, U, P, Q, C, h, v, m, scale, err_tol)

    error('this version is obsolete');
    N = size(L,2);
    V = zeros(N, m+1);
    H = zeros(m+1,m);

    beta = norm(v, 2);
    if (beta == 0)
        expH = zeros(m, 1);
        err = 0;	
        return;
    end

    V(:,1) = v / beta;

    for j = 1:m
        %precondition 1
        %w = (C+h*G)\((C-h*G)*V(:,j)); %solve Cx = Av
        
        %precondition 2
        %w = (C/h-G)\(C/h*V(:,j)); %solve Cx = Av
        w = Q*(U\(L\(P*(C/h*V(:,j)))));
        for reoth = 1:1
            for i = 1:j 
                ip = w'*V(:,i);
                H(i,j) = H(i,j) + ip;
                w = w - ip*V(:,i);
            end
        end
        H(j+1, j) = norm(w, 2);       
        V(:,j+1) = w/H(j+1,j);   
	
        %check the error 
        [expH err] = rational_EXP0(H(1:j, 1:j), eye(j, 1), scale);
        err = beta/scale*H(j+1,j)*abs(err);
        %err = abs(err);
        if (j >= 2 && err < err_tol)
            m = j;
            H = H(1:m+1, 1:m);
            V = V(:, 1:m+1);
            return;
        end

        %if H(j+1,j) < j*eps
        %    m = j; 
        %    H = H(1:m+1,1:m); V = V(:,1:m+1);
        %    return; 
        %end
    end
end
