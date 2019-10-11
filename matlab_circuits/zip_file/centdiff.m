% Centered difference approximation for sensitivities
% Ref:  Numerical Methods for Engineers, 
% S.C. Chapra & R.P. Canale, McGraw-Hill, 3rd ed, 1998, p.93
% File:  centdiff.m; updated 11/03/06.  Eliminates {Nc Nc} arrays Q and B.
% 
clear;clc
E1=1;E2=-1;R1=10;R2=100;R3=10;R4=100;
RR=[R1 R2 R3 R4 E1 E2];
Vo=DA2(RR) % Differential amplifier
Nc=length(RR);dpf=0.0001;Q=1+dpf;B=1-dpf;
Qx=ones(1,Nc);Bx=ones(1,Nc);
for p=1:Nc
   Qx(p)=Q;Bx(p)=B;
   if p > 1;Qx(p-1)=1;Bx(p-1)=1;end;
   RRx=RR.*Qx;Vr=DA2(RRx); %  fore shot   
   RRx=RR.*Bx;Vb=DA2(RRx); %  back shot
   Sen1(p)=(Vr/Vo-1)/dpf; % fore shot only
   Sen2(p)=(Vr-Vb)/(2*Vo*dpf); % fore and back shot; centered difference
   D(p)=1e6*(Sen1(p)/Sen2(p)-1); % (Meas-True)/True = Meas/True-1
end
format short g
Sen1
Sen2
disp(' ')
disp('Error (in ppm) of Sen1 compared to the more accurate Sen2:')
disp(D)
%
% Note that the sensitivities of the two inputs E1 and E2 are not 1, as is the case for
% one input.
