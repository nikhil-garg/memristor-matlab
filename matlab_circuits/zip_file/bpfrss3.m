% MFB Bandpass Filter RSS & WCA
% File: c:\M_files\bookupdate\bpfrss3.m
% updated 11/09/06
clear;clc
fo=500;wo=2*pi*fo;K=10;Q=20;
C1=0.1*1e-6;C2=C1;
% Design equations; fo exactly 500 Hz for illustration purposes.
R1=Q/(K*wo*C1);
R3=2*Q/(wo*C1);
R2=R1/(wo^2*R1*R3*C1*C2-1);
%R1=6340;R2=80.6;R3=127000;C1=0.1*1e-6;C2=C1;
Nom=[R1 R2 R3 C1 C2];
%
% Form symmetric tolerance array T
Tr=0.02;Tc=0.1;
T=[-Tr -Tr -Tr -Tc -Tc;Tr Tr Tr Tc Tc];
Nc=size(T,2);dpf=0.0001;Q=1+dpf;B=1-dpf;
Mr=1+(T(2,:)+T(1,:))/2; % For asymmetric tolerances; all 1's for symmetric
Tv=(T(2,:)-T(1,:))./(2*Mr); % Used for RSS
Nav=Nom.*Mr; % Average value of components for asymmetric tolerances.
%
% Start ac analysis
%
BF=400;LF=600;NP=201;F=linspace(BF,LF,NP);
%
for i=1:NP
   Qx=ones(1,Nc);Bx=ones(1,Nc); % Reset
   s=2*pi*F(i)*j;
   Vo(i)=G1(Nom,s);
   Va(i)=G1(Nav,s);
%
   for p=1:Nc
      Qx(p)=Q;Bx(p)=B;
      if p > 1;Q(p-1)=1;B(p-1)=1;end; % reset previous
%     
      Vr=G1(Nom.*Qx,s);Vb=G1(Nom.*Bx,s);
      Sen(i,p)=(Vr-Vb)/(2*Vo(i)*dpf);
%
% get EVA
%
      if Sen(i,p) > 0;
         Lo(p)=1+T(1,p);Hi(p)=1+T(2,p);
      else
         Lo(p)=1+T(2,p);Hi(p)=1+T(1,p);
      end
   end % end p loop
%
   VH(i)=G1(Nav.*Hi,s);VL(i)=G1(Nav.*Lo,s);
%
% get RSS
%
   STn=norm(Sen(i,:).*Tv);
   Vrss1(i)=Va(i)*(1-STn);Vrss2(i)=Va(i)*(1+STn);
%
end % freq loop i
%
h=plot(F,Sen(:,1),'k',F,Sen(:,2),'r',F,Sen(:,3),'b');
set(h,'LineWidth',2);
hold on
h=plot(F,Sen(:,4),'c',F,Sen(:,5),'m');
set(h,'LineWidth',2);
set(gca,'FontSize',8);
grid on;%hold off
axis([BF LF -15 15])
ylabel('%/%');xlabel('Freq (Hz)');
title('Fig 6. Sensitivities')
legend('R1','R2','R3','C1','C2',0)
figure
%
h=plot(F,Sen(:,1),'k',F,Sen(:,2),'r',F,Sen(:,3),'b');
hold on
set(h,'LineWidth',2);
h=plot(F,Sen(:,4),'c',F,Sen(:,5),'m');
set(h,'LineWidth',2);
set(gca,'FontSize',8);
hold off;grid on
axis([499 501 -2 2]);
YT=linspace(-2,2,9);set(gca,'ytick',YT)
ylabel('%/%');xlabel('Freq (Hz)');
title('Fig 7. Sensitivities at fo');
legend('R1','R2','R3','C1','C2',0);
text(500,1.4,'fo = 500.0 Hz','FontSize',8);
text(499.99,1.2,'\downarrow');
figure
%
h=plot(F,VL,'b',F,VH,'r',F,Va,'k--');
set(h,'LineWidth',2)
grid on
set(gca,'FontSize',8);
axis([BF LF -5 20])
xlabel('Freq (Hz)');ylabel('Volts')
title('Fig 9. EVA')
legend('EV Lo','EV Hi','Nom',0);
figure
%
h=plot(F,Vrss1,'b',F,Vrss2,'r',F,Va,'k--');
set(h,'LineWidth',2);
grid on
axis([BF LF -5 20])
set(gca,'FontSize',8);
xlabel('Freq (Hz)');ylabel('Volts')
title('Fig 8. RSS')
legend('RSS Lo','RSS Hi','Nom',0);
%


