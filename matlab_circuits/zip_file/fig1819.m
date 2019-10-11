% File:  c:\M_files\bookupdate\fig1819.m
% dc differential amplifier MCA
% function DA2 used
% revised to faster format
clear;clc;tic;
%
R1=10;R2=100;R3=10;R4=100;E1=1;E2=-1;
Nom=[R1 R2 R3 R4 E1 E2];
%
% Get nominal output
%
Vo=DA2(Nom);
%
% Specify Nk number of MCA samples and Nc components
%
Nk=20000; % <<<<<<<<<<<<<<<<<<<<< Nk
Nc=size(Nom,2);
%
% Seed for Normal and Uniform random numbers
%
randn('state',sum(100*clock));
rand('state',sum(100*clock));
%
Tn=zeros(Nc,Nk);Tu=zeros(Nc,Nk); % Reserve space; decreases run time
%
% Create tolerance array T;
% 
Tr=0.01;Te=0.05;
T=[ -Tr -Tr -Tr -Tr -Te -Te;Tr Tr Tr Tr Te Te];
% T below for fig 20 and fig 21
%T=[ -Tr -Tr -Tr -Tr -Te -Te;0.03 Tr 0.03 Tr Te Te];
%
nb=30;  % number of histogram bins   
% Convert to tolerance multipliers
for k=1:Nk
   for w=1:Nc
      Tn(w,k)=Nom(w)*(((T(2,w)-T(1,w))/6)*(randn+3)+T(1,w)+1);
      Tu(w,k)=Nom(w)*((T(2,w)-T(1,w))*rand+T(1,w)+1);
   end % end w loop
%
% Calculate Nk random Normal & Uniform outputs
%
   Vn(k)=DA2(Tn(:,k));Vu(k)=DA2(Tu(:,k));
end % end k loop
%
% Get statistics and create histograms
%
Vs1=3*std(Vn);Vavg1=mean(Vn);
h1=hist(Vn,nb)/Nk;VL=min(Vn);VH=max(Vn);
intv=(VH-VL)/nb;
q=1:nb;bin1(q)=VL+intv*(q-1); % Vectorize
Vhi1=Vavg1+Vs1;Vlo1=Vavg1-Vs1;
Vsr=sprintf('%2.3f\n',Vs1);
Vavgr=sprintf('%2.3f\n',Vavg1);
%
Vs2=3*std(Vu);Vavg2=mean(Vu);
h2=hist(Vu,nb)/Nk;VL=min(Vu);VH=max(Vu);
intv=(VH-VL)/nb;
q=1:nb;bin2(q)=VL+intv*(q-1); % Vectorize
Vhi2=Vavg2+Vs2;Vlo2=Vavg2-Vs2;
Vsu=sprintf('%2.3f\n',Vs2);
Vavgu=sprintf('%2.3f\n',Vavg2);
%
% Plot histograms (Normalized by Nk)
%
subplot(2,1,1)
bar(bin1,h1,1,'y');
grid off;
set(gca,'FontSize',8);
title('Fig 18. Diff Amp MCA, Normal dist');
axis([18.5 21.5 0 0.12]);
text(20.7,0.07,['Vavg1 = ',Vavgr],'FontSize',8);
text(20.7,0.05,['Vs1 = ',Vsr],'FontSize',8);
text(18.7,0.05,['Nk = ',num2str(Nk)],'FontSize',8);
%
subplot(2,1,2)
bar(bin2,h2,1,'y');
set(gca,'FontSize',8);
xlabel('Volts dc')
grid off;
axis([18.5 21.5 0 0.12]);
title('Fig 19. Diff Amp MCA, Uniform dist');
text(20.7,.07,['Vavg2=',Vavgu],'FontSize',8);
text(20.7,0.05,['Vs2=',Vsu],'FontSize',8);
figure(1)
ET=toc







