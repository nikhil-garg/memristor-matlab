% Temperature Sensing Test Circuit
% File: c:\M_files\bookupdate\temptest.m
% Circuit function: tc.m 
% Updated 11/08/06
clear;clc;
R1=10;R2=1;
% RTD values
R3=75.79;R4=7.355;R5=2.25;R6=0.395;
Rx=[R3 R4 R5 R6];
Nrtd=size(Rx,2);
Eref=5;D=255;
Tr=0.02;Tad=1/D; % 1 LSB error
T=[-Tr -Tr -Tad;Tr Tr Tad];
Rp=R1*R2/(R1+R2);Rin=[R1 Rp];
Nc=size(T,2);Sen=[-1 1 1]; % sensitivity signs obvious from circuit
% create M array
for p=1:Nc
   if Sen(p)>0
      M(1,p)=1+T(1,p);M(2,p)=1+T(2,p);
   else
      M(1,p)=1+T(2,p);M(2,p)=1+T(1,p);
   end
end
for w=1:Nrtd
   for u=1:2
      Va(u,w)=tc(Rin(u),Rx(w),Eref);
      nu(u,w)=floor(Va(u,w)*D/Eref+0.5);   
      nvlo(u,w)=round(D*M(1,3)*tc(Rin(u)*M(1,1),Rx(w)*M(1,2),1));
      nvhi(u,w)=round(D*M(2,3)*tc(Rin(u)*M(2,1),Rx(w)*M(2,2),1));   
   end
end
b1=str2num(dec2bin(nvlo(1,:)));
b2=str2num(dec2bin(nvlo(2,:)));
b3=str2num(dec2bin(nvhi(1,:)));
b4=str2num(dec2bin(nvhi(2,:)));
bin=[b1 b2 b3 b4];
Rin=[Rin';Rin'];
%
% Display results
%
format short g
Va
nu
nvlo
nvhi
Rx
bin
Rin


