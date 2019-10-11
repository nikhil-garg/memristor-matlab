function y = G4(X,s)
% All-pass circuit function
% X = [R1 R2 R3 R4 C1 C2];
R1=X(1);R2=X(2);R3=X(3);R4=X(4);C1=X(5);C2=X(6);
%
A(1,1)=1/R1+s*C1+s*C2;A(1,2)=-s*C1;A(1,4)=-s*C2;
A(2,1)=A(1,2);A(2,2)=1/R2+s*C1;A(2,4)=-1/R2;
A(3,3)=1/R3+1/R4;
A(4,2)=1;A(4,3)=-1; % Divide by Ao
B=[1/R1;0;1/R3;0];
C=A\B;y=(180/pi)*angle(C(4));