function y = SCF(X,s)
% function for SCF
R1=X(1);R2=X(2);R3=X(3);R4=X(4);wc=X(5);
N1=wc*R2/R1;D1=wc*R2/R3;
D0=wc^2*R2/R4;
y=abs(N1*s/(s^2+D1*s+D0));