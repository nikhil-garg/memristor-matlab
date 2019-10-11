function vo = rational_EXP1(A, v, scale)    
    M = size(A, 1);
    %T = (eye(M, M)+A)\(eye(M,M)-A)*scale;
    T = (eye(M, M) - A^-1)*scale;
    
    vo = (expm(T)-eye(M))*(T\v);
end
