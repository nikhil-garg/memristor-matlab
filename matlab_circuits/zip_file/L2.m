function y = L2(X,s)
% fcn for Butterworth LPF
R1=X(1);R2=X(2);R3=X(3);C1=X(4);C2=X(5);
A=[1/R1+1/R2+1/R3+s*C2 -1/R2;-1/R3 -s*C1];
B=[1/R1; 0];C=A\B;
y=abs(C(2));
