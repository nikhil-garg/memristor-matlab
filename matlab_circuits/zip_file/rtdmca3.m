% File c:\M_files\bookupdate\rtdmca3.m
% MCA of RTD circuit; 
% normal and uniform distribution
% uses MATLAB function G2a.m
% Note:  Inverter stage using R8 & R9 added;
%   E1 input to R8, output to E2 & R1 on
%   schematic on p.20
% Updated 11/08/06
%
clc;clear;tic;
R1=4.53;R2=34.8;R3=132;R4=9.09;R5=9.09;E1=5;
R6=4.53;R7=27.4;R8=20;R9=20;RT=1.915;
X=[R1 R2 R3 R4 R5 R6 R7 R8 R9 RT E1];
%
Vo=G2a(X);
Tinit=0.001;Tlife=0.002;ppm=1e-6;
TC1=50*ppm;TC2=25*ppm;
Thi=Tinit+Tlife+35*TC1;Tlo=-Tinit-Tlife-80*TC1;
Trhi=8.1*1e-4;Trlo=-Trhi;Trefhi=0.02+35*TC2;
Treflo=-0.02-80*TC2;
%
T=[ Tlo Tlo Tlo Tlo Tlo Tlo Tlo Tlo Tlo Trlo Treflo;
   Thi Thi Thi Thi Thi Thi Thi Thi Thi Trhi Trefhi];
Nc=size(T,2);
Nk=5000 % <<<<<<<<<<<<<<<<<<<< Nk
nb=30; % Number of histogram bins
randn('state',sum(100*clock)); % Randomize seed
rand('state',sum(100*clock));
for mc=1:2
   Tn=zeros(Nk,Nc);Vm=zeros(Nk,1);
   for k=1:Nk
      for w=1:Nc
         if mc==1 
            Rn(w,k)=X(w)*(((T(2,w)-T(1,w))/6)*(randn+3)+T(1,w)+1);
         else
            Rn(w,k)=X(w)*((T(2,w)-T(1,w))*rand+T(1,w)+1);
         end
      end
      Vm(k)=G2a(Rn(:,k));
   end
	if mc==1
      Vs1=3*std(Vm);Vavg1=mean(Vm);
      h1=hist(Vm,nb)/Nk;VL=min(Vm);VH=max(Vm);
      intv=(VH-VL)/nb;q=1:nb;
      bin1=VL+intv*(q-1);
      Vhi1=Vavg1+Vs1;Vlo1=Vavg1-Vs1;
      Vsr=sprintf('%2.3f\n',Vs1);
      Vavgr=sprintf('%2.3f\n',Vavg1);
   else
      Vs2=3*std(Vm);Vavg2=mean(Vm);
      h2=hist(Vm,nb)/Nk;VL=min(Vm);VH=max(Vm);
      intv=(VH-VL)/nb;q=1:nb;
      bin2=VL+intv*(q-1);
      Vhi2=Vavg2+Vs2;Vlo2=Vavg2-Vs2;
      Vsu=sprintf('%2.3f\n',Vs2);
      Vavgu=sprintf('%2.3f\n',Vavg2);
   end
end
subplot(2,1,1)
bar(bin1,h1,1,'y');
set(gca,'FontSize',8);
title('Fig 26. RTD MCA, Normal dist');
grid off
axis([3.9 4.7 0 0.15]);
text(3.95,0.1,['Vavg=',Vavgr],'FontSize',8);
text (3.95,0.12,['Vs=',Vsr],'FontSize',8);
%
subplot(2,1,2)
bar(bin2,h2,1,'y');
set(gca,'FontSize',8);
title('Fig 27. Uniform dist');
xlabel('Volts dc')
axis([3.9 4.7 0 0.15]);
text(3.95,0.1,['Vavg=',Vavgu],'FontSize',8);
text(3.95,0.12,['Vs=',Vsu],'FontSize',8);
figure(1)
ET=toc

   
   








