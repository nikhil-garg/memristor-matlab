% FMCA and MCA of Twin-T Notch Filter
% File:  c:\M_files\bookupdate\fmcatwint.m
% updated 11/10/06
clc;clear;tic;
K=1e3;n=1e-9;
R1=265*K;R3=R1;R5=R1/2;
C2=20*n;C4=10*n;C6=10*n;
Nom=[R1 R3 R5 C2 C4 C6];
BF=40;LF=80;NP=161;
F=linspace(BF,LF,NP);
Tr=0.02;Tc=0.1;
T=[-Tr -Tr -Tr -Tc -Tc -Tc;Tr Tr Tr Tc Tc Tc];
Nc=size(T,2);
% T2
% * * * * * * * * * * * * * Begin Template * * * * * * * * * * * * * * * * * 
% FMCA Setup
%
Nc=size(T,2);Nf=2^Nc;
Tf=zeros(Nf,Nc);
k=1:Nf;RB=dec2bin(k-1);
for k=1:Nf
   for w=1:Nc;
      if RB(k,w)=='0'
         Tf(w,k)=Nom(w)*(1+T(1,w));
      else
         Tf(w,k)=Nom(w)*(1+T(2,w));
      end
   end
end
%
% MCA Setup
%
rand('state',sum(100*clock));
%
Nk=2000; % <<<<<<<<<<<<<<<<<<<<<<<<<< Nk
%
for k=1:Nk;
   for w=1:Nc
      Tn(w,k)=Nom(w)*((T(2,w)-T(1,w))*rand+T(1,w)+1);
   end
end
%
% FMCA and MCA
%
for i=1:NP
   s=2*pi*F(i)*j;Vo(i)=T2(Nom,s); % Call circuit function
% FMCA
   for k=1:Nf      
      Vf(k,i)=T2(Tf(:,k),s); % Call circuit function
   end
% MCA
   for k=1:Nk
      Vm(k,i)=T2(Tn(:,k),s); % Call circuit function
   end
end
Vmax2=max(Vf);Vmin2=min(Vf);Vmax1=max(Vm);Vmin1=min(Vm);
%
% * * * * * * * * * * * * * End Template * * * * * * * * * * * * * * * * * 
%
h=plot(F,20*log10(Vmax2),'r',F,20*log10(Vo),'k--',F,20*log10(Vmax1),'r--');
set(h,'LineWidth',2);
hold on
h=plot(F,20*log10(Vmin2),'b',F,20*log10(Vmin1),'b--');
set(h,'LineWidth',2);
hold off;grid on
set(gca,'FontSize',8);
axis ([BF LF -100 -10])
ylabel('dBV')
title('Fig 46/47. Twin-T FMCA/MCA')
text(45,-52,['Nk = ',num2str(Nk)],'FontSize',8);
legend('FMCA Hi','Nom','MCA Hi','FMCA Lo','MCA Lo',4);
figure(1)
ET=toc
%

