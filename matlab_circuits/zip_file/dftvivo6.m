% 3rd order power supply filter MCA transient analysis
% File: c:\M_files\bookupdate\dftvivo6.m
% Uses MATLAB ODE function along with M-Files vo6.m and ps3.m
% updated 11/12/06
clc;clear;tic;
% unit suffixes
K=1e3;uF=1e-6;uH=1e-6;us=1e-6;uA=1e-6;ms=1e-3;mA=1e-3;
% component values
R1=1;R2=100;R3=1;R4=1*K;C1=1*uF;C2=5*uF;L1=600*uH;
E1=5; % +5V step input; not randomized
Nom=[R1 R2 R3 R4 C1 C2 L1 E1];Nc=size(Nom,2); % Nc = number of components
Nk=500; % Number of MCA samples
Nt=100;
% Nt = number of time points for ODE (ode23) function
%
rand('state',sum(100*clock));
Per=1*ms;
Vm3=zeros(Nt,Nk);Vm2=zeros(Nt,Nk);Ru=zeros(Nk,Nc);RU=rand(Nk,Nc);
% Initialize arrays for ODE function
tt=linspace(0,2*Per,Nt);v0=zeros(3,1);
Tr=0.02;Tc=0.1;Th=0.2;Te=0.05; % Component tolerances in decimal percent
T=[-Tr -Tr -Tr -Tr -Tc -Tc -Th -Te;
   Tr Tr Tr Tr Tc Tc Th Te];
%
% Randomize components with random array RU & tolerances T
%
for p=1:Nc
	Ru(:,p)=Nom(p)*((T(2,p)-T(1,p))*(RU(:,p))+T(1,p)+1);
end
for k=1:Nk
   [A,B]=vo6(Ru(k,:));   
   [t,v]=ode23('ps3',tt,v0,'',A,B);
   Vm3(:,k)=v(:,3);Vm2(:,k)=v(:,2);
end 
Vmax3=max(Vm3');Vmin3=min(Vm3');
Vmax2=max(Vm2');Vmin2=min(Vm2');
%
% plot
%
g=plot(t/ms,Vmax3,'r',t/ms,Vmin3,'b');
set(g,'LineWidth',2);
hold on
g=plot(t/ms,Vmax2,'k',t/ms,Vmin2,'m');
set(gca,'FontSize',8);
set(g,'LineWidth',2);
title('Power Supply Filter MCA')
ylabel('Volts');grid on
xlabel('Time (msec)');hold off
YT=linspace(0,10,11);
set(gca,'ytick',YT);
axis([0 2 0 10]);
% Position Nk text manually with cursor
gtext(['Nk = 'num2str(Nk)],'FontSize',8);
legend('VC2 Hi','VC2 Lo','VC1 Hi','VC1 Lo');
%
figure(1)
ET=toc

