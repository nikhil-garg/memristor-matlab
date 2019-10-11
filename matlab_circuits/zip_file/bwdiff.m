% Bandwidth Limited Differentiator
% File:  d:\Mfiles\bookdisk\bwdiff.m
clear;clc
% Component values
R1=1000;R2=10000;C1=10e-9;
BF=3; % beginning log frequency = 10^BF
ND=4; % number of decades
PD=20; % points per decade
w1=2*pi*100;w2=2*pi*1e6;Ao=1e5;
% oppamp characteristics
FM=linspace(BF,BF+ND,ND*PD+1);
% log Freq linear scale
for i=1:ND*PD+1
   F(i)=10^FM(i);s=0+2*pi*F(i)*j;
% s = jw
	Aol=Ao/((1+s/w1)*(1+s/w2));
% opamp open loop gain 
	Op(i)=20*log10(abs(Aol));
% dBV
%   
% create A matrix and 
% B input column vector
%   
A=[((s*C1)/(s*R1*C1+1)+1/R2) -1/R2;
   Aol 1];
B=[s*C1/(s*R1*C1+1);0];
   Va=A\B;Vo(i)=20*log10(abs(Va(2)));
% output in dBV
end
%
% plot results
%
h=plot(FM,Vo,'k',FM,Op,'k');
set(h,'LineWidth',2)
grid on
axis([BF BF+ND -20 80])
xlabel('Log Freq (Hz)');ylabel('dBV')
title('Fig.1  BW Limited Diff Amp')
% Option - print to graphics file 
%print -dmeta bwlim
%print -dhpgl bwlim 
%print -dbitmap bwlim


