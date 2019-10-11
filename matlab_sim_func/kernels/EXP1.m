function vo = EXP1(A,v)
    N = size(A,1);
    vo = (expm(A)-speye(N))*(A\v);
end
