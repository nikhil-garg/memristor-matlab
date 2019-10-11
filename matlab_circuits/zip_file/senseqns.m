% Sensitivity equations 
% for R2, R3, C1, C2 in the multiple feedback bpf.
% File:  c:\M_files\bookupdate\senseqns.m
% updated 11/09/06
clear;clc
BF=400;LF=600;NP=201;
F=linspace(400,600,NP);
fo=500;wo=2*pi*fo;G=10;Q=20;
C1=0.1*1e-6;C2=C1;
% Design equations; fo exactly 500 Hz for illustration purposes.
R1=Q/(G*wo*C1);
R3=2*Q/(wo*C1);
R2=R1/(wo^2*R1*R3*C1*C2-1);
disp(' ');
disp('R1, R2, R3');
[R1 R2 R3]
%
% The following equations were obtained by symbolic math capabilities 
% in Mathcad.  Note from the second plot that the curves do not have 
% the same zero-crossing frequency.
%
for i=1:NP
   m=2*pi*F(i); % radian frequency
   d1(i)=2*(Q^2*(wo^2-m^2)^2+(m*wo)^2);
   SR2(i)=(wo^2*(2*Q^2-G)*(wo^2-m^2))/d1(i);
   d2(i)=d1(i)/2;
   SR3(i)=wo^2*(Q^2*(wo^2-m^2)+m^2)/d2(i);
   SC1(i)=m^2*(2*Q^2*(wo^2-m^2)+wo^2)/d1(i);
   SC2(i)=m^2*(2*Q^2*(wo^2-m^2)-wo^2)/d1(i);
end
%
subplot(2,1,1)
h=plot(F,SR2,'k',F,SR3,'r',F,SC1,'g',F,SC2,'b');
set(gca,'FontSize',8);
set(h,'LineWidth',2);grid on;
axis([BF LF -15 15])
XT=linspace(BF,LF,5);
set(gca,'xtick',XT);
ylabel('%/%');
title('Fig 56. Sensitivities of R2,R3,C1,C2 MFB BPF')
legend('R2','R3','C1','C2',0);      
%
subplot(2,1,2)
h=plot(F,SR2,'k',F,SR3,'r',F,SC1,'g',F,SC2,'b');
set(gca,'FontSize',8);
set(h,'LineWidth',2);grid on;
axis([499 501 -1.5 1.5])
xlabel('Freq(Hz)');ylabel('%/%');
title('Fig 57. At fo = 500.0 Hz')
      
