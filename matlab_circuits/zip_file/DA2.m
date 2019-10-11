function y = DA2(X);
% function for dc diffamp
% X=[R1 R2 R3 R4 E1 E2]
R1=X(1);R2=X(2);R3=X(3);R4=X(4);E1=X(5);E2=X(6);
y=E1*(1+R2/R1)/(1+R3/R4)-E2*R2/R1;
