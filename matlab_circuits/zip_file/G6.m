function y = G6(X)
% fcn for offsets.m offset analysis
%G6(R1,R2,R3,R4,Vos,Ib1,Ib2)
R1=X(1);R2=X(2);R3=X(3);R4=X(4);Vos=X(5);Ib1=X(6);Ib2=X(7);
Vo=(Vos+Ib1*R1*R2/(R1+R2)-Ib2*R3*R4/(R3+R4))*(1+R2/R1);
y=Vo*1e3; % output in mV
%y=Vo;