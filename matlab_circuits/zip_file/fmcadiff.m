% FMCA of dc diff amp
% File:  c:\M_files\bookupdate\fmcadiff.m
% uses function DA2
% updated 11/10/06
clear;clc;
R1=10;R2=100;R3=10;R4=100;E1=1;E2=-1;
Nom=[R1 R2 R3 R4 E1 E2];
Vo=DA2(Nom);
Tr=0.01;Te=0.05;
T=[-Tr -Tr -Tr -Tr -Te -Te;Tr Tr Tr Tr Te Te];
% create 6-bit binary counter
Nc=size(T,2);
%
Nf=2^Nc;Tf=zeros(Nc,Nf);DB=zeros(Nf,Nc);
k=1:Nf;DB=dec2bin(k-1); % Nc-bit binary array
for k=1:Nf
   for w=1:Nc
      if DB(k,w)=='0'
  			Tf(w,k)=1+T(1,w);
  		else
  			Tf(w,k)=1+T(2,w);
  		end
   end
end
%
% insert Tf into output equation
for k=1:Nf
   Vm(k)=DA2(Nom.*Tf(:,k)');
end
VL=min(Vm);VH=max(Vm);
disp(' ')
disp('        VL             Vnom        VH')
disp([VL Vo VH])
