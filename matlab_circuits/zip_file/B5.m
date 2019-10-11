function y = B5(X,s)
% fcn for LTC1562 BPF
R1=X(1);R2=X(2);Rin=X(3);Rq=X(4);C1=X(5);C2=X(6);
N1=-1/(Rin*C2);D1=1/(Rq*C2);
D0=1/(R1*R2*C1*C2);
y=abs(N1*s/(s^2+D1*s+D0));