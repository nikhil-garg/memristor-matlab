% 3rd order Butterworth filter transient analysis
% Another example of how easy transient MCA is to implement
%   using MATLAB.
% Note that delta t is selected automatically by the ode function.
% File: c:\M_fil\bookupdate\bwfil3mca.m
% Uses functions bw3.m and ps3.m
% Revised and updated 11/12/06
%
tic;clc;clear
% unit suffixes
K=1e3;uF=1e-6;uH=1e-6;us=1e-6;uA=1e-6;ms=1e-3;mA=1e-3;
% component values
R1=1*K;R2=1*K;R3=1*K;C1=1*uF;C2=1*uF;C3=1*uF;E1=5; % 5V step input
Tr=0.01;Tc=0.1;Te=0.05;
% Order of T follows the order of Nom component vector
Nom=[R1 R2 R3 C1 C2 C3 E1];Nc=length(Nom);
T=[-Tr -Tr -Tr -Tc -Tc -Tc -Te;Tr Tr Tr Tc Tc Tc Te];
% generate random numbers
Nk=500; % Number of MCA samples
Nt=100; % Number of time points for ode23 function
%
rand('state',sum(100*clock));
Per=10*ms; % Period
Vm1=zeros(Nt,Nk);Ru=zeros(Nk,Nc);RA=rand(Nk,Nc); % uniform dist
Vm2=zeros(Nt,Nk);Vm3=zeros(Nt,Nk);
% Use fixed time increments tt; Initialize v0 for ode23 function
tt=linspace(0,Per,Nt);v0=zeros(3,1);
%
for p=1:Nc
	Ru(:,p)=Nom(p)*((T(2,p)-T(1,p))*(RA(:,p))+T(1,p)+1);
end
% The interested user should experiment with other MATLAB ODE functions.
for k=1:Nk
   [A,B]=bw3(Ru(k,:)); % call circuit program bw3
   [t,v]=ode23('ps3',tt,v0,'',A,B);
   Vm1(:,k)=v(:,1);Vm2(:,k)=v(:,2);Vm3(:,k)=v(:,3);
end
Vmax1=max(Vm1');Vmin1=min(Vm1');
Vmax2=max(Vm2');Vmin2=min(Vm2');
Vmax3=max(Vm3');Vmin3=min(Vm3');
%
subplot(2,2,1)
g=plot(t/ms,Vmax1,'r',t/ms,Vmin1,'b');
set(g,'LineWidth',2);axis auto
set(gca,'FontSize',8);
title('V1 Hi & Lo')
ylabel('Volts');grid on
xlabel('Time (ms)');
%
subplot(2,2,2)
g=plot(t/ms,Vmax2,'r',t/ms,Vmin2,'b');
set(g,'LineWidth',2);axis auto
set(gca,'FontSize',8);
title('V2 Hi & Lo')
ylabel('Volts');grid on
xlabel('Time (ms)');
%
subplot(2,2,3)
g=plot(t/ms,Vmax3,'r',t/ms,Vmin3,'b');
set(g,'LineWidth',2);axis auto
set(gca,'FontSize',8);
title('V3 Hi & Lo')
ylabel('Volts');grid on
xlabel('Time (ms)');
gtext(['Nk = 'num2str(Nk)],'FontSize',8);
%
figure(1)
disp(' ');disp('Execution time in seconds:');
ET=toc
