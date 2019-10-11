% Butterworth Lowpass Filter RSS & WCA
% File: c:\M_files\bookupdate\lpfrss2.m
% updated 11/09/06
clear;clc
R1=1430;R2=14300;R3=9090;C1=2*1e-9;C2=0.1*1e-6;
Nom=[R1 R2 R3 C1 C2];
Nc=size(Nom,2);
BF=2;ND=2;NP=101;  % log frequency sweep
dpf=0.0001;Q=1+dpf;B=1-dpf;
% Form tolerance array T
Tr=0.02;Tc=0.1;
T=[-Tr -Tr -Tr -Tc -Tc;Tr Tr Tr Tc Tc];
Mr=1+(T(2,:)+T(1,:))/2; % For asymmetric tolerances; all 1's for symmetric
Tv=(T(2,:)-T(1,:))./(2*Mr); % Used for RSS
Nav=Nom.*Mr; % Average value of components for asymmetric tolerances.
%
% Start ac analysis
%
L=linspace(BF,BF+ND,NP);
for i=1:NP
   Qx=ones(1,Nc);Bx=ones(1,Nc); % reset perturbation multipliers
   s=2*pi*10^L(i)*j;
   Vo(i)=L2(Nom,s);Va(i)=L2(Nav,s);
   for p=1:Nc
      Qx(p)=Q;Bx(p)=B;
      if p > 1;Qx(p-1)=1;Bx(p-1)=1;end;
      Vr=L2(Nom.*Qx,s);Vb=L2(Nom.*Bx,s);
      Sen(i,p)=(Vr-Vb)/(2*Vo(i)*dpf);
      if Sen(i,p)>0
         Lo(p)=1+T(1,p);Hi(p)=1+T(2,p);
      else
         Lo(p)=1+T(2,p);Hi(p)=1+T(1,p);
      end
   end
%
% get RSS
%
   STn=norm(Sen(i,:).*Tv);
   Vrss1(i)=Va(i)*(1-STn);Vrss2(i)=Va(i)*(1+STn);
%
% get EVL & EVH
%
   VH(i)=L2(Nav.*Hi,s);VL(i)=L2(Nav.*Lo,s);
end % end i freq loop
%
subplot(2,1,1)
h=plot(L,Sen(:,1),'k',L,Sen(:,2),'r',L,Sen(:,3),'g');
hold on
g=plot(L,Sen(:,4),'b',L,Sen(:,5),'m');
set(h,'LineWidth',2);set(g,'LineWidth',2)
hold off;grid on
set(gca,'FontSize',8);
axis([BF BF+ND -1.5 1.5])
ylabel('%/%','FontSize',8)
title('Fig 10. LPF Sensitivities','FontSize',8)
legend('R1','R2','R3','C1','C2');
%
subplot(2,1,2)
h=plot(L,20*log10(VL),'b',L,20*log10(VH),'r');
set(h,'LineWidth',2)
hold on
h=plot(L,20*log10(Vrss1),'b--',L,20*log10(Vrss2),'r--');
set(h,'LineWidth',2)
grid on
set(gca,'FontSize',8);
axis([BF BF+ND -20 30])
xlabel('Freq (Hz)','FontSize',8);ylabel('dBV','FontSize',8)
title('Fig 11. LPF EVA','FontSize',8)
legend('EVA Lo','EVA Hi','RSS Lo','RSS Hi',0);
figure(1)


