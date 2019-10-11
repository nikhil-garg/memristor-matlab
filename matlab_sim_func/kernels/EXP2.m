function vo = EXP2(A,v)
    N = size(A,1);
    vo = (expm(A)-A-speye(N))*(A\(A\v));
end
