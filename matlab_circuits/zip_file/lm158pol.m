% LM158 Stability Analysis - polar plot
% File: c:\M_files\bookupdate\lm158pol.m
% no functions used
% updated 11/09/06
clear;clc;
K=1e3;u=1e-6;p=1e-12;Meg=1e6;
Rx=101.2433*Meg; % internal to IC
Cx=80*p; % internal to IC
%Cx=200*p; % more stable
R4=1130;R6=2260;R19=10*K;C2=0.1*u;
% opamp poles
w1=1/(Rx*Cx);w2=2*pi*1.2*1e6;w3=4*pi*1e6;
Ao=1e5; % opamp dc open loop gain
% linear frequency, NP points
NP=200;BF=1e6;LF=1e7;DF=(LF-BF)/NP;
% tolerances
Tr=0.02;Tc=0.1;Ta=0.2;Trx=0.1;
% Tr = resistor tolerances
% Tc = capacitor C2 tolerance
% Ta = Ao tolerance
% Trx = w1 tolerance
% Tolerance array T
T=[-Tr -Tr -Tr -Tc -Ta -Trx;Tr Tr Tr Tc Ta Trx];
Nc=6;dpf=0.0001;Q=dpf*eye(Nc)+1;
Lit=(LF-BF)/DF;
F=linspace(BF,LF,Lit);
for i=1:Lit
   s=2*pi*F(i)*j;
   A=Ao/((1+s/w1)*(1+s/w2)*(1+s/w3));
   Al(i)=20*log10(abs(A));
   % inverse Beta
   B=(s+(1/R19+1/R6+1/R4)/C2)/(s+1/(R19*C2));
   Bl(i)=20*log10(abs(B));
   G1=A/B;GH(i)=abs(G1);
   M(i)=20*log10(GH(i));  % loop gain
   Ph(i)=angle(G1);  % radians for polar plot
   for p=1:Nc
      A=Ao*Q(p,5)/((1+s/(w1*Q(p,6)))*...
         (1+s/w2)*(1+s/w3));
      B=(s+(1/(R19*Q(p,3))+1/(R6*Q(p,2))+1/...
         (R4*Q(p,1)))/(C2*Q(p,4)))...
         /(s+1/(R19*Q(p,3)*C2*Q(p,4)));
      GHr(i)=abs(A/B);
      SM(i,p)=((GHr(i)/GH(i))-1)/dpf;
% SM = sensitivities
      if SM(i,p)>0
         L(i,p)=1+T(1,p);H(i,p)=1+T(2,p);
      else
         L(i,p)=1+T(2,p);H(i,p)=1+T(1,p);
      end
   end
   % get EVL
   A=Ao*L(i,5)/((1+s/(w1*L(i,6)))...
      *(1+s/w2)*(1+s/w3));
   B=(s+(1/(R19*L(i,3))+1/(R6*L(i,2))+1/...
      	(R4*L(i,1)))/(C2*L(i,4)))...
      	/(s+1/(R19*L(i,3)*C2*L(i,4)));
   GHL(i)=abs(A/B);
   % get EVH
   A=Ao*H(i,5)/((1+s/(w1*H(i,6)))*...
      (1+s/w2)*(1+s/w3));
   B=(s+(1/(R19*H(i,3))+1/(R6*H(i,2))+1/...
   	(R4*H(i,1)))/(C2*H(i,4)))...
      /(s+1/(R19*H(i,3)*C2*H(i,4)));
   GHH(i)=abs(A/B);
   % get RSS
   sum1(i)=0;sum2(i)=0;
   for p=1:Nc
      sum1(i)=sum1(i)+(SM(i,p)*(L(i,p)-1))^2;
      sum2(i)=sum2(i)+(SM(i,p)*(H(i,p)-1))^2;
   end
   Grss1(i)=GH(i)*(1-sqrt(sum1(i)));
   Grss2(i)=GH(i)*(1+sqrt(sum2(i)));
end
% create polar plot
h=polar([0 2*pi],[0 2]);
delete(h);hold on
g=polar(Ph,GH,'k');set(g,'LineWidth',2);
g=polar(Ph,Grss1,'r');set(g,'LineWidth',2);
g=polar(Ph,Grss2,'g');set(g,'LineWidth',2);
g=polar(Ph,GHL,'c');set(g,'LineWidth',2);
g=polar(Ph,GHH,'b');set(g,'LineWidth',2);
set(gca,'FontSize',8);
%gtext('Fig 16. RSS/EVA, Cx = 80pF','FontSize',8)
title('Fig 16. RSS/EVA, Cx = 80pF');
hold off
legend('GH','Grss1','Grss2','GHL','GHH',0);
figure(1)