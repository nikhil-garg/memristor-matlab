% File c:\M_files\bookupdate\daratio.m
% dc differential amplifier - ratiometric analysis
% compare histograms with ?
% updated 11/11/06
clear;clc;tic;
R1=10;R2=100;R3=10;R4=100;E1=1;E2=-1;
K1=R2/R1;K2=R3/R4; % Ratios K1 & K2
% Ratio tolerances
Tr=0.01;Te=0.05;
T=[-Tr -Tr -Te -Te;Tr Tr Te Te];
Nc=size(T,2);
Nk=10000;
Tn=zeros(Nk,Nc);Tu=Tn;
%
nb=30; % Number of histgram bins   
rand('state',sum(100*clock)); % randomize seed for Uniform RNG
randn('state',sum(100*clock)); % randomize seed for Normal RNG
%
for k=1:Nk
   for w=1:Nc
      Tn(k,w)=((T(2,w)-T(1,w))/6)*(randn+3)+T(1,w)+1;
      Tu(k,w)=(T(2,w)-T(1,w))*rand+T(1,w)+1;
   end
%
   An=K1*(Tn(k,1));Bn=K2*(Tn(k,2));
   Vn(k)=E1*Tn(k,3)*(1+An)/(1+Bn)-E2*Tn(k,4)*An;
%
   Au=K1*(Tu(k,1));Bu=K2*(Tu(k,2));
   Vu(k)=E1*Tu(k,3)*(1+Au)/(1+Bu)-E2*Tu(k,4)*Au;
end
%
Vs1=3*std(Vn);Vavg1=mean(Vn);
h1=hist(Vn,nb)/Nk;VL=min(Vn);VH=max(Vn); % Histogram normalized by Nk
intv=(VH-VL)/nb;
q=1:nb;bin1(q)=VL+intv*(q-1); % Vectorize
Vhi1=Vavg1+Vs1;Vlo1=Vavg1-Vs1;
Vsr=sprintf('%2.3f\n',Vs1);
Vavgr=sprintf('%2.3f\n',Vavg1);
%
Vs2=3*std(Vu);Vavg2=mean(Vu);
h2=hist(Vu,nb)/Nk;VL=min(Vu);VH=max(Vu);
intv=(VH-VL)/nb;
q=1:nb;bin2(q)=VL+intv*(q-1);
Vhi2=Vavg2+Vs2;Vlo2=Vavg2-Vs2;
Vsu=sprintf('%2.3f\n',Vs2);
Vavgu=sprintf('%2.3f\n',Vavg2);
%
subplot(2,1,1)
bar(bin1,h1,1,'y');
title('Fig 22. Ratiometric MCA, Normal dist');
grid off;
axis([18.5 21.5 0 0.12]);
set(gca,'FontSize',8);
text(20.5,0.08,['Vavg1=',Vavgr],'FontSize',8);
text(20.5,0.06,['Vs1=',Vsr],'FontSize',8);
text(20.5,0.045,['Nk = ',num2str(Nk)],'FontSize',8);
%
subplot(2,1,2)
bar(bin2,h2,1,'y');
title('Fig 23. Ratiometric MCA, Uniform dist');
xlabel('Volts dc')
grid off;
axis([18.5 21.5 0 0.12]);
set(gca,'FontSize',8);
text(20.5,0.08,['Vavg2=',Vavgu],'FontSize',8);
text(20.5,0.06,['Vs2=',Vsu],'FontSize',8);
figure(1)
ET=toc







