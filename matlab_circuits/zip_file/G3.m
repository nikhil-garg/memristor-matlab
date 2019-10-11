function y = G3(X,s)
% Sallen & Key BPF transfer function
R1=X(1);R2=X(2);R3=X(3);R4=X(4);R5=X(5);C1=X(6);C2=X(7);
N1=(1+R5/R4)/(R1*C1);
D1=(1/R1-R5/(R2*R4)+2/R3)/C1;
D0=(1/R1+1/R2)/(R3*C1*C2);
y=abs(N1*s/(s^2+D1*s+D0));