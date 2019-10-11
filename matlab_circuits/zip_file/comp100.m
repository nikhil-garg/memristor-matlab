% File: c:\M_files\bookupdate\comp100.m
% 100 Hz clock generator comparator
% Updated 11/08/06
clc;clear;tic;
R1=1e5;R2=1e5;R3=1e5;R4=5750;R5=3300;
E1=5;C6=1e-6;Vlo=0.25; % Vlo is the saturation voltage of an LM339 comparator.
X=[R1 R2 R3 R4 R5 C6 E1 Vlo];
Fn=c100(X); % Nominal clock frequency
% start MCA
Tr=0.02;Tc=0.1;Te=0.05;Tv=0.2;
T=[-Tr -Tr -Tr -Tr -Tr -Tc -Te -Tv;Tr Tr Tr Tr Tr Tc Te Tv];
Nc=size(T,2);
%
Nk=10000; % <<<<<<<<<<<<<<<<<< Nk
%
rand('state',sum(100*clock));
randn('state',sum(100*clock));
for mc=1:2 % Normal then uniform   
   for k=1:Nk
      for w=1:Nc
         if mc==1
            Tn(w,k)=X(w)*(((T(2,w)-T(1,w))/6)*(randn+3)+T(1,w)+1);
         else
            Tn(w,k)=X(w)*((T(2,w)-T(1,w))*rand+T(1,w)+1);
         end
   	  end % end w loop
      D=c100(Tn(:,k));
      Fm(k)=100*((D/Fn)-1);  % percent variation for horiz axis of plots
      Fa(k)=D; % for mean and sigma
   end % end k loop
   nb=30; % Number of histogram bins
   if mc==1
      Fs1=3*std(Fa);Favg1=mean(Fa);
      h1=hist(Fm,nb)/Nk;
      FL=min(Fm);FH=max(Fm);
   	  intv=(FH-FL)/nb;
   	  q=1:nb;bin1(q)=FL+intv*(q-1);
   	  Fsr=sprintf('%3.2f\n',Fs1);Favgr=sprintf('%3.2f\n',Favg1);
	else
   	  Fs2=3*std(Fa);Favg2=mean(Fa);
   	  h2=hist(Fm,nb)/Nk;FL=min(Fm);FH=max(Fm);
   	  intv=(FH-FL)/nb;
   	  q=1:nb;bin2(q)=FL+intv*(q-1);
   	  Fsu=sprintf('%3.2f\n',Fs2);Favgu=sprintf('%3.2f\n',Favg2);
   end
end % end mc loop
%
subplot(2,1,1)
bar(bin1,h1,1,'y');
set(gca,'FontSize',8);
title('100 Hz clock gen, Normal dist input');
grid off
axis([-15 15 0 0.12]);
YT=linspace(0,0.12,7);
set(gca,'ytick',YT);
text(-14,0.1,['Favg(Hz)=',Favgr],'FontSize',8);
text(-14,0.08,['Fs(Hz)=',Fsr],'FontSize',8);
text(-14,0.06,['Nk = ',num2str(Nk)],'FontSize',8);
%
subplot(2,1,2)
bar(bin2,h2,1,'y');
set(gca,'FontSize',8);
title('Uniform dist input');xlabel('% Variation')
axis([-15 15 0 0.12]);
YT=linspace(0,0.12,7);
set(gca,'ytick',YT);
text(-14,0.1,['Favg(Hz)=',Favgu],'FontSize',8);
text(-14,0.08,['Fs(Hz)=',Fsu],'FontSize',8);
figure(1)
ET=toc
