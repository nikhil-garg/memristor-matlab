% uA733 Video Ampl MCA
% File:  c:\M_files\bookupdate\uA733.m
% For schematic, see uA733.doc
% uses function files VA7.m & ccs.m
% constant-current_source analysis
% updated 11/11/06
clear;clc;tic;
Ra=[300 400];  % Constant current sources (CCS) have two different emitter resistors
% and hence two different currents.
Be=100;E3=15; % Nominal BJT beta = 100
R1=10e3;R2=1.4e3;
for b=1:2
	Re=Ra(b);
	Ie(b)=ccs(R1,R2,Re,Be,E3);
end
Ia=Ie(1);Ib=Ie(2); % CCS currents
%
R3=50;R5=50;R1=2400;R2=2400;R9=1100;R10=1100;
R11=7000;R12=7190;R4=590;R6=590;Be=100;
Vo=VA7(R1,R2,R3,R4,R5,R6,R9,R10,R11,R12,Be,Ia,Ia,Ib,Ib);
% Tn is the numerator tolerance of the resistor ratio
% Td is the denominator tolerance
% Tr is the ratio (tracking) tolerance
% Tc is the external carbon resistor tolerance = 10%
%
Nk=10000; %<<<<<<<<<<<<<<<<<<< Nk
%
Tn=0.3;Td=0.3;Tr=0.05;Tc=0.1;k=1;c=0;
rand('state',sum(100*clock)); % randomize RNG
%
while k < Nk
	T2(k)=Td*(2*rand-1);
	T3(k)=Tr*(2*rand-1);
	T1(k)=(1+T2(k))*(1+T3(k))-1;
	if T1(k) > -Tn & T1(k) < Tn % accept ratiometric tolerance
		T1(k)=1+T1(k);T2(k)=1+T2(k);
		T4(k)=Tc*(2*rand-1)+1;
		Vm(k)=VA7(R1*T1(k),R2*T2(k),R3*T4(k),R4*T1(k),R5*T4(k),...
			R6*T2(k),R9*T1(k),R10*T2(k),R11*T1(k),R12*T2(k),...
			Be,Ia,Ia,Ib,Ib);
		k=k+1;  % increment sample counter
	else
		c=c+1; % count rejections
	end
end
%
%  The ratioed resistors are R1/R2, R4/R6, R9/R10, & R11/R12
%
nb=30; % number of histogram bins 
Vs=std(Vm);Vavg=mean(Vm); % Histogram normalized by Nk
h1=hist(Vm,nb)/Nk;VL=min(Vm);VH=max(Vm);
intv=(VH-VL)/nb;
q=1:nb;bin(q)=VL+intv*(q-1);
Vs3=sprintf('%3.2f\n',3*Vs);Vsav=sprintf('%3.2f\n',Vavg);
%
subplot(2,1,1)
bar(bin,h1,1,'y');
title('uA733 MCA Histogram');
grid off
xlabel('Gain (V/V)');ylabel('bin/Nk');
set(gca,'FontSize',8);
axis([9.2 10.8 0 0.05]);
text(10.5,0.04,['Vavg=',Vsav],'FontSize',8);
% Vs3 (3-sigma) is meaningful only for Gaussian outputs
%text(10.5,0.04,['3*Vs=',Vs3],'FontSize',8);
text(10.5,0.035,['Nk = ',num2str(Nk)],'FontSize',8)
figure(1)
%
format short e;Ie % ccs currents
format short g;Vo
ET=toc