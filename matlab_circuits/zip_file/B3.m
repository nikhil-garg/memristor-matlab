function y = B3(X,s)
% fcn for Delyiannis BPF
% X=[R1 R2 Ra Rb C1 C2]
R1=X(1);R2=X(2);Ra=X(3);Rb=X(4);C1=X(5);C2=X(6);
N1=(Ra+Rb)/(R1*C2*Rb);
D1=(1/C1+1/C2)/R2-Ra/(R1*C2*Rb);
D0=1/(R1*R2*C1*C2);
y=abs(N1*s/(s^2+D1*s+D0));