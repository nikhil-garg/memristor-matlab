% Percent yield of diff amp
% File: pcyield.m
% uses function DA2.m
% Updated 11/06/06
clear;clc;
R1=10;R2=100;R3=10;R4=100;E1=1;E2=-1;
X=[R1 R2 R3 R4 E1 E2];
Vo=DA2(X);
Nk=200; % Number of samples
Nc=size(X,2);
randn('state',sum(100*clock)); % randomize seed for RNG.
Rn=zeros(Nk,Nc);Vm=zeros(Nk,1);
% set test limits at desired levels
% UL = Vo+0.7; LL = Vo-0.7 
UL=20.7;LL=20-0.7;LM=[LL UL];
%
for r=1:5 % Try different resistor tolerances
% clear fail counters
   flo=0;fhi=0;
   Tr=r/100;Te=0.05; % when r=1, Tr-0.01 = 1%, etc.
   Trm(r)=Tr;Tem(r)=Te;
   T=[ -Tr -Tr -Tr -Tr -Te -Te;Tr Tr Tr Tr Te Te];
   for k=1:Nk
      for p=1:Nc
         Rn(p,k)=X(p)*(((T(2,p)-T(1,p))/6)*(randn+3)+T(1,p)+1);
  	   end
      Vm(k)=DA2(Rn(:,k));
% catch high failures
      if Vm(k)>UL;fhi=fhi+1;end
% catch low failures
      if Vm(k)<LL;flo=flo+1;end
   end
   NFH(r)=fhi;NFL(r)=flo;
   pcy(r)=100*(1-(fhi+flo)/Nk); % Percent yield
   Vs=3*std(Vm);Vavg=mean(Vm); % Mean & standard deviation
   Vhi(r)=Vavg+Vs;Vlo(r)=Vavg-Vs;
end   
disp('Display upper limit and lower limit in Volts dc.')
LM
disp('Number of samples')
Nk
disp('Display data matrix MV')
disp('row 1 of MV:  Resistor decimal tolerances')
disp('row 2; Input voltage tolerances in decimal percent')
disp('row 3; Vavg - 3sigma = Vavg - Vs for that resistor tolerance')
disp('row 4; Vavg + 3sigma = Vavg + Vs   "   "      "         "')
disp('row 5; Number of runs failing high "   "      "         "')
disp('row 6; Number of runs failing low  "   "      "         "')
disp('row 7; Percent yield               "   "      "         "')
disp(' ')
% 
MV=[Trm;Tem;Vlo;Vhi;NFH;NFL;pcy]

