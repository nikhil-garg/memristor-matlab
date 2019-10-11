function y = B6(X,s)
% matrix fcn for Sallen & Key BPF
% R1,R2,R3,R4,R5,C1,C2,s
R1=X(1);R2=X(2);R3=X(3);R4=X(4);R5=X(5);C1=X(6);C2=X(7);
Ao=1e6;
A=[1/R1+1/R2+s*(C1+C2) -s*C2 0 -1/R2;
-s*C2 1/R3+s*C2 0 0;
0 0 1/R4+1/R5 -1/R5;
0 -Ao Ao 1];
B=[1/R1;0;0;0];
C=A\B;y=abs(C(4));