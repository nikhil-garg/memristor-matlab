function y = B2(X,s)
% function for Mult Fdbk BPF
R1=X(1);R2=X(2);R3=X(3);C1=X(4);C2=X(5); 
N1=1/(R1*C1);
D1=(1/C1+1/C2)/R3;
D0=(1/R1+1/R2)/(R3*C1*C2);
y=abs(N1*s/(s^2+D1*s+D0));