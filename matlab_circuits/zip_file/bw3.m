function [A,B]=bw3(X)
% Create W, P, Q, & S arrays
% for 3rd order Butterworth LPF
% X = [R1 R2 R3 C1 C2 C3 E1]
R1=X(1);R2=X(2);R3=X(3);C1=X(4);C2=X(5);C3=X(6);
E1=X(7);
W=[R1 R1 0;R2 0 0;0 0 R3];
P=diag([C1 C2 C3]);
Q=[-1 0 0;0 0 -1;1 -1 -(1+R3/R2)];S=[E1;0;0];
C=W*P;
A=C\Q;B=C\S;

