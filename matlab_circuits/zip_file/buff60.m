% FMCA and MCA of buffered
% 60Hz notch filter
% File: c:\M_files\bookupdate\buff60.m
% updated 11/10/06
clc;clear;tic;
K=1e3;n=1e-9;
R1=19*K;R2=57.6*K;R3=464*K;R4=200;
R5=4.8*K;C1=46*n;C2=C1;C3=C1;
Nom=[R1 R2 R3 R4 R5 C1 C2 C3];
Nc=size(Nom,2);
BF=40;LF=80;NP=161;
F=linspace(BF,LF,NP);
Tr=0.01;Tc=0.1;
T=[-Tr -Tr -Tr -Tr -Tr -Tc -Tc -Tc;
   Tr Tr Tr Tr Tr Tc Tc Tc];
%
% G5
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
   s=2*pi*F(i)*j;Vo(i)=G5(Nom,s); % Call circuit function
% FMCA
   for k=1:Nf      
      Vf(k,i)=G5(Tf(:,k),s); % Call circuit function
   end
% MCA
   for k=1:Nk
      Vm(k,i)=G5(Tn(:,k),s); % Call circuit function
   end
end
Vmax2=max(Vf);Vmin2=min(Vf);Vmax1=max(Vm);Vmin1=min(Vm);
%
% * * * * * * * * * * * * * End Template * * * * * * * * * * * * * * * * * 
%
h=plot(F,Vmax2,'r',F,Vo,'k--',F,Vmin2,'b');
set(h,'LineWidth',2);grid on
hold on
h=plot(F,Vmax1,'r--',F,Vmin1,'b--');
set(h,'LineWidth',2);grid on
hold off
set(gca,'FontSize',8);
axis ([BF LF -70 10])
ylabel('dBV')
title('Fig 54./55. Buffered Notch')
text(46,-26,['Nk = ',num2str(Nk)],'FontSize',8);
legend('FMCA Hi','Nom','FMCA Lo','MCA Hi','MCA Lo',0);
figure(1)
ET=toc
