function f=c100(X)
%100 Hz comparator clock generator
R1=X(1);R2=X(2);R3=X(3);R4=X(4);R5=X(5);C6=X(6);E1=X(7);Vlo=X(8);
A=[1/R1+1/R2+1/R3 -1/R3;-1/R3 1/R3+1/R5];
B=[E1/R1;E1/R5];
C=A\B;Vhi=C(2);Va=C(1);
KI1=1+R1*(1/R2+1/R3);KI2=1+R3*(1/R1+1/R2);
Vb=E1/KI1+Vlo/KI2;
Rpar=R4+rp(R5,rp(R3,rp(R1,R2)));
% can use recursive calls as in Mathcad
tau1=Rpar*C6;tau2=R4*C6;
Tf=tau1*log((Vhi-Vb)/(Vhi-Va))+tau2*log((Vlo-Va)/(Vlo-Vb));
f=1/Tf;
%
function r=rp(a,b)
% parallel resistance of 2 resistors
r=a*b/(a+b);
