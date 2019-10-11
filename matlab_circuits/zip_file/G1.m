function y = G1(X,s)
% bpf function with matrices
R1=X(1);R2=X(2);R3=X(3);C1=X(4);C2=X(5);
A=[1/R1+1/R2+s*(C1+C2) -s*C2;s*C1 1/R3];
B=[1/R1;0];C=A\B;
y=abs(C(2));