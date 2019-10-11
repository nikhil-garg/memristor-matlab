% Generating Gaussian random numbers with MATLAB
% File:  c:\M_files\bookupdate\genorm.m
% updated 11/10/06
% Added color to heavier plot traces; 
% Added legend to plot and explanatory headers
% Consistent symbols used, e.g., Nc, Nk, etc.
% Deleted output file output.txt
%  
clear;clc;
Nk=5; % number random samples
Nc=3; % number of components (resistors)
% Resistor (component) values:
R1=1000;R2=100;R3=10;
%
% Tolerance array T for R1, R2, & R3:
% R2 and R3 have asymmetric tolerances
%
T=[-0.02 -0.01 -0.02;0.02 0.02 0.01]
%
disp(' ');
disp('Nominal resistor values');
disp('        R1           R2           R3')
disp([R1 R2 R3]);
disp(' ')
%
% Generate random Normal (Gaussian) numbers Z with 
% 0 mean and standard deviation (sigma) of 1.
%
for k=1:Nk
   for w=1:Nc
      Z(k,w)=randn; % MATLAB's Gaussian RNG
   end
end
% output Z to screen. (Z will be different for each run.)
% Display column headers for Z
disp('      For R1       For R2       For R3');
%  
Z
% Gaussian random tolerances
for i=1:7
   x(i)=i-4; % x varies from -3 sigma to +3 sigma
   T1(i)=((T(2,1)-T(1,1))/6)*(x(i)+3)+T(1,1); %  symmetric tolerances of +/- 2%
   T2(i)=((T(2,2)-T(1,2))/6)*(x(i)+3)+T(1,2); % asymmetric tolerances of +2% & -1%
   T3(i)=((T(2,3)-T(1,3))/6)*(x(i)+3)+T(1,3); % asymmetric tolerances of +1% & -2%
end
%
for k=1:Nk
   r1(k)=R1*((T(2,1)-T(1,1))/6*(Z(k,1)+3)+T(1,1)+1);
   r2(k)=R2*((T(2,2)-T(1,2))/6*(Z(k,2)+3)+T(1,2)+1);
   r3(k)=R3*((T(2,3)-T(1,3))/6*(Z(k,3)+3)+T(1,3)+1);
end
%
disp(' ')
disp('Random resistor values per Z and T')
disp(' ')
disp('        R1           R2           R3')
disp(' ')
disp([r1' r2' r3'])
%
% plot T1, T2, & T3
h=plot(x,T1,'r',x,T2,'b',x,T3,'k');
set(h,'LineWidth',2);
set(gca,'FontSize',8);
axis([-3 3 -0.02 0.02])
grid on
xlabel('Sigma');ylabel('Decimal %');
title('Fig 17. Decimal Tolerances')
legend('+2% -2%','+2% -1%','+1% -2%',4);

   