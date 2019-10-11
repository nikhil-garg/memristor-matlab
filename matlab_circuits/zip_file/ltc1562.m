% FMCA and MCA of LTC1562 BPF
% File:  c:\M_files\bookupdate\ltc1562.m
% uses fcn B5.m
% updated 11/09/06
clc;clear;tic;
K=1e3;p=1e-12;Meg=1e6;
R1=10*K;R2=1*Meg;Rq=2*Meg;Rin=200*K;
C1=159.15*p;C2=C1;
Nom=[R1 R2 Rin Rq C1 C2];
Nc=size(Nom,2);Nf=2^Nc;
BF=8000;LF=12000;NP=101;
F=linspace(BF,LF,NP);
Tr=0.01;Tc=0.1;
T=[-Tr -Tr -Tr -Tr -Tc -Tc;Tr Tr Tr Tr Tc Tc];
Tf=zeros(Nc,Nf);
%
Nf=2^Nc;Tn=zeros(Nc,Nf);DB=zeros(Nf,Nc);
k=1:Nf;DB=dec2bin(k-1);
for k=1:Nf
   for w=1:Nc
      if DB(k,w)=='0'
  			Tf(w,k)=1+T(1,w);
  		else
  			Tf(w,k)=1+T(2,w);
  		end
   end
end
%
rand('state',sum(100*clock));
%
Nk=1000; % <<<<<<<<<<<<<<<<<<<<<<< Nk
Tn=zeros(Nc,Nk);
%
for k=1:Nk
   for w=1:Nc
      Tn(w,k)=Nom(w)*((T(2,w)-T(1,w))*rand+T(1,w)+1);
   end
end
for i=1:NP
   s=2*pi*F(i)*j;
   Vo(i)=B5(Nom,s);
   for q=1:Nf
      Vf(q,i)=B5(Nom.*Tf(:,q)',s);
   end
   for k=1:Nk
      Vm(k,i)=B5(Tn(:,k),s);
   end
end
Vmax1=max(Vm);Vmin1=min(Vm);
Vmax2=max(Vf);Vmin2=min(Vf);
%
h=plot(F/K,Vmax1,'r--',F/K,Vo,'k--',F/K,Vmin1,'b--');
set(h,'LineWidth',2);
hold on
h=plot(F/K,Vmax2,'r',F/K,Vmin2,'b');
set(h,'LineWidth',2);grid on
set(gca,'FontSize',8);
hold off
axis([BF/K LF/K 0 12])
ylabel('Volts');xlabel('Freq (KHz)');
title('Fig 48/49. LTC1562 BPF')
text(8.2,8.4,['Nk = ',num2str(Nk)],'FontSize',8);
legend('MCA Hi','Nom','MCA Lo','FMCA Hi','FMCA Lo',0);
figure(1)
ET=toc