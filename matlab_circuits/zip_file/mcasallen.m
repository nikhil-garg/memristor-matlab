% MCA of Sallen & Key BPF
% File:  c:\M_files\bookupdate\mcasallen.m
% uses matrix analysis and function B6.m
% updated 11/09/06
clear;clc;tic;
R1=15800;R2=5110;R3=2610;R4=3320;
R5=13300;C1=1e-7;C2=C1;
Nom=[R1 R2 R3 R4 R5 C1 C2];
BF=400;LF=600;NP=101;
% Tolerance array
% Precision tolerances
Tr=0.001;Tc=0.02;
T=[-Tr -Tr -Tr -Tr -Tr -Tc -Tc;...
   Tr Tr Tr Tr Tr Tc Tc];
% generate Nk random normal 
% numbers for Nc components
%
Nk=1000; % <<<<<<<<<<<<<<<<<<<<< Nk
%
Nc=size(Nom,2);
randn('state',sum(100*clock)); % randomize seeds
rand('state',sum(100*clock));
Tn=zeros(Nc,Nk);Tu=zeros(Nc,Nk);
F=linspace(BF,LF,NP);
%
for k=1:Nk
   for w=1:Nc
      Tn(w,k)=Nom(w)*(((T(2,w)-T(1,w))/6)*(randn+3)+T(1,w)+1);
      Tu(w,k)=Nom(w)*((T(2,w)-T(1,w))*rand+T(1,w)+1);
   end   
end
for i=1:NP
   s=2*pi*F(i)*j;
   Vo(i)=B6(Nom,s);
   for k=1:Nk
      Vn(k,i)=B6(Tn(:,k),s);Vu(k,i)=B6(Tu(:,k),s);
   end
end
%
Vmax1=max(Vn);Vmax2=max(Vu);Vmin1=min(Vn);Vmin2=min(Vu);
%
h=plot(F,Vmax1,'r--',F,Vo,'k--',F,Vmax2,'r');
set(h,'LineWidth',2);
hold on
h=plot(F,Vmin1,'b--',F,Vmin2,'b');
hold off
set(gca,'FontSize',8);
set(h,'LineWidth',2);
s1='Fig 42/43. Sallen & Key';
s2='BPF Uniform & Normal MCA';
s3=strcat(s1,s2);
title(s3)
grid on
axis([400 600 0 12]);
text(420,7.6,['Nk = ',num2str(Nk)],'FontSize',8);
ylabel('Volts');xlabel('Freq(Hz)');
legend('Normal Hi','Nom','Uniform Hi','Normal Lo','Uniform Lo',0);
figure(1)
ET=toc
%
   

