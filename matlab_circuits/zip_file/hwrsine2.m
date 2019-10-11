% File:  c:\M_files\bookupdate\hwrsine2.m
% Half-wave rectified sine wave using 
% uses functions HWR.m & simp3a.m integration routine
% 400 Hz Full-wave rectifier circuit transient analysis
% For schematic, see hwrsine2.doc
% updated 11/11/06
clear;clc
K=1e3;u=1e-6;ms=1e-3;
F=400;T=1/F;Lit=3*T; % 3 cycles
R7=100;R8=20*K;C2=1.1*u;R5=20*K;R6=10*K;R1=630;R2=14*K;
V1=0.25*R2*sqrt(2)/R1;w=2*pi*F;NP=600;Nh=10;
% NP = number of time points; Nh = number of Fourier harmonics 
% V1 is U1A output in Volts peak (Vpk) See schematic.
bl=linspace(0,Lit,NP);
% get HWR waveform f1 input to R6 (10K)
% and sinewave (SW) f2 input to R5 (20K)
for i=1:NP
   t=bl(i);t1=mod(t,T);
   f1(i)=HWR(V1,w,t1,T); % -2*HWR for illustration
   f2(i)=V1*sin(w*t+pi); % SW for illustration
   f3(i)=V1*abs(sin(w*t));  % FWR for filtering
end
A0=simp3a(f3,NP);
% A0 is dc average of FWR (s/b 2*V1/pi = 5V)
% get coefficients C for FWR using simp3a integration routine
%
N1=R7*R8*C2/R5;N0=R8/R5;D1=C2*(R7+R8);D0=1; % N1s/(s^2+D1s+D0)
dc=A0*N0/D0
for k=1:Nh
   for i=1:NP
      va(k,i)=f3(i)*cos(k*w*bl(i));vb(k,i)=f3(i)*sin(k*w*bl(i));
   end
% Get harmonic coefficients A(k) and B(k)
   A(k)=2*simp3a(va(k,:),NP);B(k)=2*simp3a(vb(k,:),NP);
   C(k)=sqrt(A(k)^2+B(k)^2);
   if A(k)==0
      ph(k)=pi/2;
   else
      ph(k)=-atan(B(k)/A(k));
   end
%
% U3A filter magnitude transfer function
%
   G(k)=sqrt((N0^2+(k*w*N1)^2)/(D0^2+(k*w*D1)^2));
   Dn=atan(k*w*D1/D0)-pi;
   th(k)=atan(k*w*N1/N0)-Dn;
end
% inverse Fourier Transform 
for i=1:NP
   gsum(i)=0;
   for k=1:Nh
      gsum(i)=gsum(i)+2*C(k)*G(k)*cos(k*w*bl(i)+ph(k)+th(k));
   end
   gsum(i)=dc+gsum(i);   
end
%
subplot(2,1,1)
h=plot(bl/ms,f2,'r',bl/ms,f1,'b');
set(h,'LineWidth',2)
grid off;ylabel('Volts');
title('Sinewave & HWR inputs')
set(gca,'FontSize',8); 
%
subplot(2,1,2)
h=plot(bl/ms,gsum,'k');
axis([0 8 4.9 5.1]);
set(h,'LineWidth',2)
grid off;ylabel('Volts');xlabel('msec');
title('FWR Ripple');
set(gca,'FontSize',8);
figure(1)
