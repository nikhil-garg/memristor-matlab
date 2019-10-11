% Sallen & Key BPF RSS & WCA
% File: c:\M_files\bookupdate\skevafmcatf.m
% combined FMCA & EVA for S&K BPF
% uses MATLAB function G3.m
% updated 11/08/06
%
clear;clc
R1=15800;R2=5110;R3=2610;R4=3320;R5=13300;
C1=1e-7;C2=C1;
X=[R1 R2 R3 R4 R5 C1 C2];
BF=400;LF=600;NP=201; % Beginning frequency; last frequency; number of points
dpf=0.0001;Q=1+dpf;B=1-dpf;
% Form tolerance array T
Tr=0.02;Tc=0.1;
T=[-Tr -Tr -Tr -Tr -Tr -Tc -Tc;Tr Tr Tr Tr Tr Tc Tc];
Nc=size(T,2);
% Start ac analysis
F=linspace(BF,LF,NP);
for i=1:NP
   Qx=ones(1,Nc);Bx=ones(1,Nc);
   s=2*pi*F(i)*j;
   Vo(i)=G3(X,s);
   for p=1:Nc
      if p > 1
         Qx(p)=Q;Bx(p)=B;
         Qx(p-1)=1;Bx(p-1)=1;
      else
         Qx(p)=Q;Bx(p)=B;
      end
      Vr=G3(X.*Qx,s);Vb=G3(X.*Bx,s);
      Sen(i,p)=(Vr-Vb)/(2*Vo(i)*dpf);
      if Sen(i,p) > 0
         L(p)=1+T(1,p);H(p)=1+T(2,p);
      else
         L(p)=1+T(2,p);H(p)=1+T(1,p);
      end
   end % end p loop
% get EVH
   VH(i)=G3(X.*H,s);VL(i)=G3(X.*L,s); % Do not plot VL
end
% start FMCA
Nf=2^Nc;Tf=zeros(Nc,Nf);DB=zeros(Nf,Nc);
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
for i=1:NP
   s=2*pi*F(i)*j;
   for k=1:Nf;Vm(k,i)=G3(X.*Tf(:,k)',s);end;
end
Vmax=max(Vm);
%
m=plot(F,VH,'b',F,Vo,'k--',F,Vmax,'r');
set(m,'LineWidth',2)
set(gca,'FontSize',8);
grid on
axis([BF LF 0 30])
xlabel('Freq (Hz)');ylabel('Volts')
title('Fig 41. EVA & FMCA')
legend('EVA Hi','Nom','FMCA Hi',0);
figure(1)



