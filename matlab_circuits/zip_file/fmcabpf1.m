% FMCA of Bandpass Filter
% File:  c:\M_files\bookupdate\fmcabpf1.m
% function B2 used
% updated 11/10/06 
clc;clear;
R1=6340;R2=80.6;R3=127000;C1=0.1*1e-6;C2=C1;
Nom=[R1 R2 R3 C1 C2];
BF=400;LF=600;NP=101;F=linspace(BF,LF,NP);
% Component tolerances in decimal percent
Tr1=0.02;Tc1=0.1;Tr2=0.02;Tc2=0.1;
T=[-Tr1 -Tr1 -Tr1 -Tc1 -Tc1;Tr2 Tr2 Tr2 Tc2 Tc2];
Nc=size(T,2);
%
% generate 2^Nc = 2^5 = 32 tolerance combinations (FMCA) 
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
   for k=1:Nf;Vf(k,i)=B2(Nom.*Tf(:,k)',s);end;
end
Vmax1=max(Vf);Vmin1=min(Vf); % FMCA
%
% MCA
%
rand('state',sum(100*clock));
%
Nk=1000; %<<<<<<<<<<<<<<<<<<<<<<<< Nk
%
for k=1:Nk
   for w=1:Nc
      Tn(w,k)=Nom(w)*((T(2,w)-T(1,w))*rand+T(1,w)+1);
   end
end
for i=1:NP
   s=2*pi*F(i)*j;
   Vo(i)=B2(Nom,s);
   for k=1:Nk;Vm(k,i)=B2(Tn(:,k),s);end;
end
Vmax2=max(Vm);Vmin2=min(Vm); % MCA
%
h=plot(F,Vmax1,'r',F,Vo,'k--',F,Vmin1,'b');
set(h,'LineWidth',2);
hold on
h=plot(F,Vmax2,'r--',F,Vmin2,'b--');
set(h,'LineWidth',2);
hold off
set(gca,'FontSize',8);
grid on
axis ([BF LF 0 15])
xlabel('Freq(Hz)');ylabel('Volts')
YT=linspace(0,15,16);
set(gca,'ytick',YT); 
title('Figs 34./35./36 BPF FMCA')
s1='Nk = ';s2='Vpk = ';
text(410,10.5,[s1,num2str(Nk)],'FontSize',8);
Vpk=max(Vmax1);
text(410,12.5,[s2,num2str(Vpk)],'FontSize',8);
legend('FMCA Hi','Nom','FMCA Lo','MCA Hi','MCA Lo',1);

