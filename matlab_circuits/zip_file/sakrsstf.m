% Sallen & Key BPF RSS & WCA
% File: c:\M_files\bookupdate\sakrsstf.m
% updated 11/09/06
clear;clc
R1=15800;R2=5110;R3=2610;R4=3320;R5=13300;
C1=1e-7;C2=C1;
Nom=[R1 R2 R3 R4 R5 C1 C2];
BF=400;LF=600;NP=201;
Nc=size(Nom,2);dpf=0.0001;Q=1+dpf;B=1-dpf;
% Form tolerance array T
Tr=0.02;Tc=0.1;
T=[-Tr -Tr -Tr -Tr -Tr -Tc -Tc;Tr Tr Tr Tr Tr Tc Tc];
Mr=1+(T(2,:)+T(1,:))/2; % For asymmetric tolerances; all 1's for symmetric
Tv=(T(2,:)-T(1,:))./(2*Mr); % Used for RSS
Nav=Nom.*Mr; % Average value of components for asymmetric tolerances.
%
% Start ac analysis
%
F=linspace(BF,LF,NP);
for i=1:NP
   Qx=ones(1,Nc);Bx=ones(1,Nc);
   s=2*pi*F(i)*j;
   Vo(i)=G3(Nom,s);Va(i)=G3(Nav,s);
   for p=1:Nc
      Qx(p)=Q;Bx(p)=B;
      if p > 1;Qx(p-1)=1;Bx(p-1)=1;end;
      Vr=G3(Nom.*Qx,s);Vb=G3(Nom.*Bx,s);
      Sen(i,p)=(Vr-Vb)/(2*Vo(i)*dpf); % Centered difference sensitivities
      if Sen(i,p)>0
         Lo(p)=1+T(1,p);Hi(p)=1+T(2,p);
      else
         Lo(p)=1+T(2,p);Hi(p)=1+T(1,p);
      end
   end
   % get RSS
   STn=norm(Sen(i,:).*Tv);
   Vrss1(i)=Va(i)*(1-STn);Vrss2(i)=Va(i)*(1+STn);
%
% get EVL & EVH
   VH(i)=G3(Nav.*Hi,s);VL(i)=G3(Nav.*Lo,s);
end
%
subplot(2,2,1)
h=plot(F,Sen(:,1),'k',F,Sen(:,2),'r',F,Sen(:,3),'g');
set(gca,'FontSize',8);
set(h,'LineWidth',2);
hold on
h=plot(F,Sen(:,4),'b');
set(h,'LineWidth',2);
grid on;hold off
axis([BF LF -20 20])
ylabel('%/%')
title('Fig 37. Sensitivities');
legend('R1','R2','R3','R4',-1);
%
subplot(2,2,2)
h=plot(F,Sen(:,5),'k',F,Sen(:,6),'r',F,Sen(:,7),'b');
set(gca,'FontSize',8);
set(h,'LineWidth',2);
grid on
axis([BF LF -20 20])
ylabel('%/%')
title('Fig 38. Sensitivities');
legend('R5','C1','C2',-1);
%
subplot(2,2,3)
h=plot(F,Vrss1,'b',F,Vrss2,'r',F,Vo,'k--');
set(gca,'FontSize',8);
set(h,'LineWidth',2)
grid on
axis([BF LF -10 20])
xlabel('Freq (Hz)');
ylabel('Volts')
title('Fig 39. RSS');
%
subplot(2,2,4)
h=plot(F,VL,'b',F,VH,'r',F,Vo,'k--');
set(gca,'FontSize',8);
set(h,'LineWidth',2)
grid on
axis([BF LF -10 20])
xlabel('Freq (Hz)');
ylabel('Volts')
title('Fig 40. EVA');
figure(1)


