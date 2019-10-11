function [A,B]=vo6(X)
% X = [R1 R2 R3 R4 C1 C2 L1 E1]
% Step input, E1 = 5
R1=X(1);R2=X(2);R3=X(3);R4=X(4);C1=X(5);C2=X(6);L1=X(7);
E1=X(8);
% Create W, P, Q, & S arrays 
W=[0 1+R3/R4 1;1 0 R3;0 R2 -R3];
P=diag([L1 C1 C2]);
Q=[1 -1/R4 0;-R1 0 -1;0 -1 1];
S=[0;E1;0];
C=W*P;
A=C\Q;B=C\S;
