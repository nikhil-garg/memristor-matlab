% FMCA and MCA of all-pass filter
% File:  allpass2.m
% Updated 11/03/06
clc;clear;tic;
K=1e3;u=1e-6;
R1=619;R2=22.6*K;R3=24.9*K;R4=226*K;
C1=0.1*u;C2=C1;
Nom=[R1 R2 R3 R4 C1 C2];
BF=450;LF=550;NP=101;
F=linspace(BF,LF,NP);
Tr=0.01;Tc=0.05; % 5% capacitors
T=[-Tr -Tr -Tr -Tr -Tc -Tc;Tr Tr Tr Tr Tc Tc];
%
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
Nk=1000; % <<<<<<<<<<<<<<<<<<<<<<<<<< Nk
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
   s=2*pi*F(i)*j;Vo(i)=G4(Nom,s); % Call circuit function
% FMCA
   for k=1:Nf      
      Vf(k,i)=G4(Tf(:,k),s); % Call circuit function
   end
% MCA
   for k=1:Nk
      Vm(k,i)=G4(Tn(:,k),s); % Call circuit function
   end
end
Vmax2=max(Vf);Vmin2=min(Vf);Vmax1=max(Vm);Vmin1=min(Vm);
%
% * * * * * * * * * * * * * End Template * * * * * * * * * * * * * * * * * 
% 
h=plot(F,Vmax2,'r',F,Vo,'k--',F,Vmax1,'r--');
set(h,'LineWidth',2);grid on
hold on
h=plot(F,Vmin2,'b',F,Vmin1,'b--');
set(h,'LineWidth',2);
hold off
set(gca,'FontSize',8);
%axis auto
axis ([BF LF 60 180])
ylabel('Phase Angle (deg)');xlabel('Freq (Hz)');
title('Fig 50./51. MFB All-Pass')
YT=linspace(60,180,13);
set(gca,'ytick',YT);
legend('FMCA Hi','Nom','MCA Hi','FMCA Lo','MCA Lo',0);
text(510,145,['Nk = ',num2str(Nk)],'FontSize',8);
figure(1)
ET=toc
%
