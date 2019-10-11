% File c:\M_files\bookupdate\rtdrss.m
% Tolerance analysis of RTD circuit
% uses MATLAB function G2.m
% updated 11/09/06
clear;clc
%
% Step 1
% Resistor values in KOhms
R1=4.53;R2=34.8;R3=132;R4=9.09;R5=9.09;R6=4.53;R7=27.4;
R8=20;R9=20;RT=1.915;Eref=5;
%
% Steps 2 & 3
%
Nom=[R1 R2 R3 R4 R5 R6 R7 R8 R9 RT Eref];
Nc=size(Nom,2);Vo=G2a(Nom); % Nominal output value
%
% Steps 4 and 5
%
dpf=0.0001;Q=1+dpf;B=1-dpf;
Qx=ones(1,Nc);Bx=ones(1,Nc); % Set dpf multipliers Q and B to 1's
%
% Step 6 and 7 Get sensitivities
%
for p=1:Nc
   Qx(p)=Q;Bx(p)=B;
   if p > 1;Qx(p-1)=1;Bx(p-1)=1;end;
   Vr=G2a(Nom.*Qx);Vb=G2a(Nom.*Bx);
   Sen(p)=(Vr-Vb)/(2*dpf*Vo); 
end
%
% Step 8 "Real world" asymmetric tolerances
%
Tinit=0.001;Tlife=0.002;ppm=1e-6;TC1=50*ppm;TC2=25*ppm;
Thi=Tinit+Tlife+35*TC1;Tlo=-Tinit-Tlife-80*TC1;
Trhi=8.1e-4;Trlo=-Trhi;Treflo=-0.02-80*TC2;Trefhi=0.02+35*TC2;
%
% Form tolerance array T
%
p=1:9;T(1,p)=Tlo;T(2,p)=Thi;
T(1,10)=Trlo;T(1,11)=Treflo;
T(2,10)=Trhi;T(2,11)=Trefhi;
Mr=1+(T(2,:)+T(1,:))/2; % For asymmetric tolerances; all 1's for symmetric
Nav=Nom.*Mr; % Average value of components for asymmetric tolerances.
Va=G2a(Nav); % Average output value with asymmetric tolerances
%
% Step 9 EVA multipliers
%
for p=1:Nc
   if Sen(p)>0
      Lo(p)=1+T(1,p);Hi(p)=1+T(2,p);  
   else
      Lo(p)=1+T(2,p);Hi(p)=1+T(1,p);     
   end
end
%
% Step 10 EVA
%
VH=G2a(Nav.*Hi);VL=G2a(Nav.*Lo);
%
% Step 11 RSS
%
Tv=(T(2,:)-T(1,:))./(2*Mr); 
STn=norm(Sen.*Tv);
Vrss1=Va*(1-STn);Vrss2=Va*(1+STn);
%
% output to command window.
%
format short
disp('     Vrss Lo    Vo      EVA Lo')
disp('     Vrss Hi    Va      EVA Hi')
disp(' ')
[Vrss1 Vo VL;Vrss2 Va VH]





