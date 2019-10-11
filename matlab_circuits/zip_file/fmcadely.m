% FMCA and MCA of Delyiannis BPF
% File:  c:\M_files\bookupdate\fmcadely.m
% uses function B3
% updated 11/10/06
clc;clear;
K=1e3;n=1e-9;
R1=4930;R2=205*K;Ra=10*K;Rb=252*K;
C1=10*n;C2=C1;
Nom=[R1 R2 Ra Rb C1 C2];
BF=400;LF=600;NP=101;
F=linspace(BF,LF,NP);
Tr=0.02;Tc=0.1; % Common tolerances
T=[-Tr -Tr -Tr -Tr -Tc -Tc;Tr Tr Tr Tr Tc Tc];
Nc=size(T,2);
%
Nf=2^Nc;Tf=zeros(Nc,Nf);DB=zeros(Nf,Nc);
k=1:Nf;DB=dec2bin(k-1); % Nc-bit binary array
for k=1:Nf
   for w=1:Nc
      if DB(k,w)=='0'
  			Tf(w,k)=1+T(1,w);
  		else
  			Tf(w,k)=1+T(2,w);
  		end
   end
end
for i=1:NP
   s=2*pi*F(i)*j;
   for k=1:Nf;Vf(k,i)=B3(Nom.*Tf(:,k)',s);end;
end
Vmax1=max(Vf);Vmin1=min(Vf); % FMCA
%
% MCA
%
rand('state',sum(100*clock));
%
Nk=2000; %<<<<<<<<<<<<<<<<<<<<<<<< Nk
%
for k=1:Nk
   for w=1:Nc
      Tn(w,k)=Nom(w)*((T(2,w)-T(1,w))*rand+T(1,w)+1);
   end
end
for i=1:NP
   s=2*pi*F(i)*j;
   Vo(i)=B3(Nom,s);
   for k=1:Nk;Vm(k,i)=B3(Tn(:,k),s);end;
end
Vmax2=max(Vm);Vmin2=min(Vm); % MCA
%
h=plot(F,Vmax1,'r',F,Vo,'k--',F,Vmin1,'b');
set(h,'LineWidth',2);grid on
hold on
h=plot(F,Vmax2,'r--',F,Vmin2,'b--');
set(h,'LineWidth',2);grid on
set(gca,'FontSize',8);
hold off
axis ([BF LF 0 1400])
ylabel('Volts')
title('Fig 44./45. Delyiannis BPF FMCA/MCA')
text(410,700,['Nk = ',num2str(Nk)],'FontSize',8);
legend('FMCA Hi','Nom','FMCA Lo','MCA Hi','MCA Lo',1);
figure(1)
%


