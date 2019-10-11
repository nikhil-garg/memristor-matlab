% FMCA and MCA of Switched-Capacitor Filter (BPF)
% File:  c:\M_files\bookupdate\scfbpf.m
% updated 11/09/06
clc;clear;tic;
% fc = 51kHz switching frequency
fc=51e3;wc=(2*pi*fc)/50;
R1=1.585e6;R2=10e3;R3=1.593e6;R4=25.4e3;
X=[R1 R2 R3 R4 wc];
BF=540;LF=740;NP=201;
F=linspace(BF,LF,NP);
% Tf = 5% fc tolerance; Tr = 2% resistor tolerance
Tr=0.02;Tf=0.05;
T=[-Tr -Tr -Tr -Tr -Tf;Tr Tr Tr Tr Tf];
Nc=size(T,2);Nf=2^Nc;
Tf=zeros(Nc,Nf);Vf=zeros(Nf,NP);
k=1:Nf;DB=dec2bin(k-1);
for k=1:Nf % Begin FMCA
   for w=1:Nc
      if DB(k,w)=='0'
         Tf(w,k)=1+T(1,w);
      else
         Tf(w,k)=1+T(2,w);
      end
   end
   for i=1:NP
      s=2*pi*F(i)*j;
      Vf(k,i)=SCF(X.*Tf(:,k)',s);
   end
end % end FMCA loop k
%
rand('state',sum(100*clock)); % randomize RNG seed
%
Nk=2000; % <<<<<<<<<<<<<<<<<<<<< Nk
Tn=zeros(Nc,Nk);Vm=zeros(Nk,NP);
%
for k=1:Nk % Begin MCA
   for w=1:Nc
      Tn(w,k)=X(w)*((T(2,w)-T(1,w))*rand+T(1,w)+1);
   end
   for i=1:NP
      s=2*pi*F(i)*j;
      Vo(i)=SCF(X,s);
      Vm(k,i)=SCF(Tn(:,k),s);
   end
end
Vmax1=max(Vm);Vmin1=min(Vm);
Vmax2=max(Vf);Vmin2=min(Vf);
%
h=plot(F,Vmax1,'g',F,Vmin1,'c');
set(h,'LineWidth',2);grid on
hold on
h=plot(F,Vmax2,'r',F,Vo,'k--',F,Vmin2,'b');
hold off
set(gca,'FontSize',8);set(h,'LineWidth',2);
axis ([BF LF 0 1.2])
ylabel('Volts');xlabel('Freq (Hz)');
title('Fig 52 & 53 SCF BPF MCA/FMCA')
YT=linspace(0,1.2,7);
set(gca,'ytick',YT);
text(560,0.5,['Nk = ',num2str(Nk)],'FontSize',8);
legend('MCA Hi','MCA Lo','FMCA Hi','Nom','FMCA Lo',0);
figure(1)
ET=toc
