% LM158 Stability Analysis
% File: c:\M_files\bookupdate\lm158ta.m
% no functions used
% updated 11/09/06
clear;clc;
K=1e3;u=1e-6;p=1e-12;Meg=1e6;
Rx=101.2433*Meg; % Rx is internal to IC
Cx=80*p; % Cx is internal to IC
%Cx=200*p;  % improves phase margin
R4=1130;R6=2260;R19=10*K;C2=0.1*u;
w1=1/(Rx*Cx);w2=2*pi*1.2*1e6;w3=4*pi*1e6;  % opamp poles
Ao=1e5;  % opamp open loop gain
BF=0;ND=7;PD=20;NP=71;
Tr=0.02;Tc=0.1;Ta=0.2;Trx=0.1;
T=[-Tr -Tr -Tr -Tc -Ta -Trx;Tr Tr Tr Tc Ta Trx];
Nc=6;dpf=0.0001;Q=dpf*eye(Nc)+1;
L=linspace(BF,BF+ND,NP);
for i=1:NP
   F=10^(L(i));s=2*pi*F*j;
%  Opamp open loop gain (OLG)
   A=Ao/((1+s/w1)*(1+s/w2)*(1+s/w3));
   Al(i)=20*log10(abs(A)); 
   % inverse Beta
   B=(s+(1/R19+1/R6+1/R4)/C2)/(s+1/(R19*C2));
   Bl(i)=20*log10(abs(B));
%  Loop gain
   G1=A/B;GH(i)=abs(G1);M(i)=20*log10(GH(i)); % loop gain
   Ph(i)=(180/pi)*angle(G1)+180;
%   unwrap(Ph(i));
   if Ph(i)>180;Ph(i)=Ph(i)-360;end;
   for p=1:Nc
      A=Ao*Q(p,5)/((1+s/(w1*Q(p,6)))*(1+s/w2)*(1+s/w3));
      B=(s+(1/(R19*Q(p,3))+1/(R6*Q(p,2))+1/(R4*Q(p,1)))/(C2*Q(p,4)))...
         /(s+1/(R19*Q(p,3)*C2*Q(p,4)));
      GHr(i)=abs(A/B);SM(i,p)=((GHr(i)/GH(i))-1)/dpf; % sensitivities
   end
end
%
subplot(2,2,1)
h=plot(L,M,'k',L,Al,'r',L,Bl,'b');
set(h,'LineWidth',2);grid on;
set(gca,'FontSize',8);
axis([BF BF+ND -20 120])
xlabel('Log Freq(Hz)','FontSize',8);
ylabel('dBV','FontSize',8);
title('Fig. 12, Bode Plot of gains','FontSize',8)
XT=linspace(BF,BF+ND,BF+ND+1);
set(gca,'xtick',XT);
legend('LG','OpampOLG','InvB',1);
%
subplot(2,2,2)
g=plot(L,Ph,'k');grid on;
set(g,'LineWidth',2);
set(gca,'FontSize',8);
axis([BF BF+ND -100 200])
xlabel('Log Freq(Hz)');
ylabel('Phase (deg)');
title('Fig 13. LG Phase','FontSize',8);
XT=linspace(BF,BF+ND,BF+ND+1);
set(gca,'xtick',XT);
%
subplot(2,2,3)
g=plot(Ph,M,'k');grid on;
set(g,'LineWidth',2);
set(gca,'FontSize',8);
axis([-100 200 -40 80])
xlabel('Phase','FontSize',8);
ylabel('Mag (dBV)','FontSize',8);
title('Fig 14. Mag vs Phase','FontSize',8);
XT=linspace(-100,200,7);
set(gca,'xtick',XT);
%
subplot(2,2,4)
h=plot(L,SM(:,1),'r',L,SM(:,2),'b',L,SM(:,3),'k');
set(h,'LineWidth',2);
hold on;grid on
h=plot(L,SM(:,4),'g',L,SM(:,5),'m',L,SM(:,6),'c');
set(h,'LineWidth',2);
set(gca,'FontSize',8);
hold off
axis([BF BF+ND -1.5 1.5])
xlabel('Log Freq (Hz)','FontSize',8);
ylabel('%/%','FontSize',8);
title('Fig. 15 Sensitivities','FontSize',8)
XT=linspace(BF,BF+ND,BF+ND+1);
set(gca,'xtick',XT);
legend('R4','R6','R19','C2','Ao','w1',4);
figure(1)
