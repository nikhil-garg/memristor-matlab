% dc differential amplifier
% File:  c:\M_files\bookupdate\diffamp.m
% Circuit function:  DA2.m
% updated version 11/12/06; symmetric tolerances 
clear;clc
R1=10;R2=100;R3=10;R4=100;E1=1;E2=-1;
Nom=[R1 R2 R3 R4 E1 E2];
Vo=DA2(Nom); % Nominal output Vo
Nc=size(Nom,2);dpf=0.0001;
Qx=ones(1,Nc);Bx=ones(1,Nc); % reset perturbation vectors Q & R
Q=1+dpf;B=1-dpf;
Tr=0.01;Te=0.05;
T=[-Tr -Tr -Tr -Tr -Te -Te;Tr Tr Tr Tr Te Te];
% For assymetric tolerances if any
Mr=1+(T(2,:)+T(1,:))/2; % Mr all 1's for symmetric tolerances.
Tv=(T(2,:)-T(1,:))./(2*Mr);
%
for p=1:Nc
   Qx(p)=Q;Bx(p)=B;
   if p > 1;Qx(p-1)=1;Bx(p-1)=1;end % reset previous
   Vr=DA2(Nom.*Qx);
   Vb=DA2(Nom.*Bx);
   Sen(p)=(Vr-Vb)/(2*Vo*dpf); % Sensitivities
   if Sen(p) > 0
      Lo(p)=1+T(1,p);Hi(p)=1+T(2,p); % For EVA
   else
      Lo(p)=1+T(2,p);Hi(p)=1+T(1,p);
   end
end
VL=DA2(Nom.*Lo); % VL = EVA Low
VH=DA2(Nom.*Hi); % VH = EVA High
% RSS
STn=norm(Sen.*Tv);
Vrss1=Vo*(1-STn);Vrss2=Vo*(1+STn);
V1=[Vrss1 Vo VL;Vrss2 Vo VH];
format short
disp('Differential Amplifier');
disp(' ');
disp('     RSS      NOM       EVA');
disp(V1);
disp(' ')
disp('Sensitivities in %/%');
disp(Sen);



