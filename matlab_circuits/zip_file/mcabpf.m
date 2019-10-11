% MCA of Bandpass Filter
% File:  c:\M+files\bookupdate\mcabpf.m
% Transfer function method;
% uses function B2.m
% updated 11/09/06
clear;clc;tic;
R1=6340;R2=80.6;R3=127000;C1=0.1*1e-6;C2=C1;
Nom=[R1 R2 R3 C1 C2];
BF=400;LF=650;NP=251;
Tr1=0.02;Tc1=0.15;Tr2=0.01;Tc2=0.1;
% Asymmetric tolerances
T=[-Tr1 -Tr1 -Tr1 -Tc1 -Tc1;Tr2 Tr2 Tr2 Tc2 Tc2];
%
Nk=1000; %<<<<<<<<<<<<<<<<<<<<<<<< Nk
%
Nc=size(Nom,2);
randn('state',sum(100*clock));
rand('state',sum(100*clock));
F=linspace(BF,LF,NP);
for k=1:Nk
   for w=1:Nc
      Tn(w,k)=Nom(w)*(((T(2,w)-T(1,w))/6)*(randn+3)+T(1,w)+1);
      Tu(w,k)=Nom(w)*((T(2,w)-T(1,w))*rand+T(1,w)+1);
   	end
end
for i=1:NP
   s=2*pi*F(i)*j;
   Vo(i)=B2(Nom,s);
   for k=1:Nk
      Vn(k,i)=B2(Tn(:,k),s);Vu(k,i)=B2(Tu(:,k),s);
   end
end
% get statistics   
Vmax1=max(Vn);Vmin1=min(Vn);
Vmax2=max(Vu);Vmin2=min(Vu);
%
h=plot(F,Vmax1,'r--',F,Vmin1,'b--',F,Vo,'k--');
set(gca,'FontSize',8);
set(h,'LineWidth',2);grid on
hold on
h=plot(F,Vmax2,'r',F,Vmin2,'b');
hold off
set(h,'LineWidth',2);
xlabel('Freq (Hz)');ylabel('Volts');
title('Fig 30/31, BPF MCA');
text(405,7.2,['Nk = ',num2str(Nk)],'FontSize',8);
legend('Normal Hi','Normal Lo','Nom','Uniform Hi','Uniform Lo',0);
figure(1)
ET=toc

