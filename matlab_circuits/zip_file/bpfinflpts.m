% Bandpass filter - C1 non-monotonicity vs. sensitivity
% File:  bpfinflpts.m
% Circuit function: B2w.m
% Improved version 3/01/04
%
% Note slope of plots as they intersect the uparrow at 1.0.  The slope 
% (normalized sensitivity) increases from 470 (red), 480 (blue), to 
% 490Hz (green), and becomes zero at 500 Hz (black).  Correspondingly,
% the negative slopes at 510 (purple), 520 (lt blue), & 530Hz (red) decrease.
% The 3rd and 4th graphs plot these magnitudes in %/%.
%
clear;clc;K=1e3;uF=1e-6;
%
% Precise value of R's for fo = 500.0 Hz
R1=6366.198;R2=80.585;R3=127323.954;
C1=0.1*uF;C2=C1;
BF=470;LF=530;NP=7; % i.e., 470Hz, 480Hz, 490Hz,...,530Hz
% set up A(k), +/-20% variable
m2=1.2;m1=0.8;W=50;dpf=0.0001; % Multiply by 0.8 and 1.2
F=linspace(BF,LF,NP);
for i=1:NP
	w=2*pi*F(i);   
	for k=1:W+1
		A(k)=((m2-m1)/W)*(k-1)+m1;
		Vo(i,k)=B2w(R1,R2,R3,C1*A(k),C2,w);
		Vr=B2w(R1,R2,R3,C1*A(k)*(1+dpf),C2,w);
		Vb=B2w(R1,R2,R3,C1*A(k)*(1-dpf),C2,w);      
		Sen(i,k)=(Vr-Vb)/(2*Vo(i,k)*dpf);
	end
end
%
subplot(2,2,1)
h=plot(A,Vo(1,:),'r',A,Vo(2,:),'b',A,Vo(3,:),'g',A,Vo(4,:),'k');
set(h,'LineWidth',2);
set(gca,'FontSize',8);
title('470Hz to 500Hz');
grid on
xlabel('C1 multiplier');
ylabel('Volts');
text(0.995,2,'\uparrow');
axis([0.8 1.2 0 12])
legend('470','480','490','500',0);
%
subplot(2,2,2)
h=plot(A,Vo(5,:),'m',A,Vo(6,:),'c',A,Vo(7,:),'r');
set(h,'LineWidth',2);
grid on
ylabel('Volts');
axis([0.8 1.2 0 12])
set(gca,'FontSize',8);
title('510Hz to 530Hz');
xlabel('C1 multiplier');
text(0.995,2,'\uparrow');
legend('510','520','530',0);
%
subplot(2,2,4)
h=plot(F,Sen(:,26),'k--o');
set(h,'LineWidth',2);
ylabel('%/%')
axis([460 540 -12 12]);
grid on
set(gca,'FontSize',8);
xlabel('Freq (Hz)');
title('Sensitivities');
%
subplot(2,2,3)
h=plot(470,Sen(1,26),'r--o',480,Sen(2,26),'b--o',490,Sen(3,26),'g--o');
set(h,'LineWidth',2);
hold on
h=plot(500,Sen(4,26),'k--o',510,Sen(5,26),'m--o');
set(h,'LineWidth',2);
h=plot(520,Sen(6,26),'c--o',530,Sen(7,26),'r--o');
hold off
set(h,'LineWidth',2);
set(gca,'FontSize',8);
axis([460 540 -12 12]);
grid on
title('Normalized Slopes');
xlabel('Freq (Hz)');ylabel('%/%')
%
figure(1)
