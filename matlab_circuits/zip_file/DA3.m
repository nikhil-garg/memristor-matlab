function [y] = DA3(RR);
% function for dc diffamp
% unpack array RR
R1=RR(1);R2=RR(2);R3=RR(3);R4=RR(4);E1=RR(5);E2=RR(6);
Vo=E1*(1+R2/R1)/(1+R3/R4)-E2*R2/R1;
y=Vo;
