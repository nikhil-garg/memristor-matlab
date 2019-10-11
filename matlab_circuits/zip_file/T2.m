function y = T2(X,s)
% fcn for twin-T passive notch filter
R1=X(1);R3=X(2);R5=X(3);C2=X(4);C4=X(5);C6=X(6);
%
A(1,1)=1/R5+s*(C4+C6);A(1,3)=-s*C6;
A(2,2)=1/R1+1/R3+s*C2;A(2,3)=-1/R3;
A(3,1)=A(1,3);A(3,2)=A(2,3);
A(3,3)=1/R3+s*C6;
B=[s*C4;1/R1;0];
C=A\B;y=abs(C(3));
