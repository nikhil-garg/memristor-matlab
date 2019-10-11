function y=VA7(R1,R2,R3,R4,R5,R6,R9,R10,R11,R12,Be,I1,I2,I3,I4)
% uA733 Video Ampl analysis
Is=3e-12; % Isat for Vbe refinement
U=30.5;% for Vbe refinement; reciprocal of the diode constant.
E1=4.1;E2=4.0;E3=15;
Vbe=[0.6 0.6 0.6 0.6 0.6 0.6];
N=18;A=zeros(N);B=zeros(N,1);
A(1,1)=1/R3;A(1,13)=1;B(1)=E1/R3; % A matrix & B col vector row 1
A(2,2)=1/R5;A(2,14)=1;B(2)=E2/R5; % row 2
A(3,3)=1/R1+1/R11;A(3,10)=-1/R11;A(3,13)=Be;A(3,16)=1;B(3)=E3/R1;
A(4,4)=1/R2+1/R12;A(4,11)=-1/R12;A(4,14)=Be;A(4,15)=1;B(4)=E3/R2;
A(5,5)=1/R4;A(5,7)=-1/R4;A(5,13)=-(1+Be); % row 5
A(6,6)=1/R6;A(6,7)=-1/R6;A(6,14)=-(1+Be); % row 6
A(7,7)=1/R4+1/R6;A(7,5)=-1/R4;A(7,6)=-1/R6;B(7)=-I1; % row 7
A(8,8)=1/R9;A(8,15)=Be;A(8,18)=1;B(8)=E3/R9; % row 8
A(9,9)=1/R10;A(9,16)=Be;A(9,17)=1;B(9)=E3/R10; % row 9
A(10,10)=1/R11;A(10,3)=-1/R11;A(10,17)=-(1+Be);B(10)=-I3; % row 10
A(11,11)=1/R12;A(11,4)=-1/R12;A(11,18)=-(1+Be);B(11)=-I4; % row 11
A(12,15)=1+Be;A(12,16)=1+Be;B(12)=I2; % row 12
A(13,1)=1;A(13,5)=-1;A(14,2)=1;A(14,6)=-1; % row 13 & 14
A(15,4)=1;A(15,12)=-1;A(16,3)=1;A(16,12)=-1; % row 15 & 16
A(17,9)=1;A(17,10)=-1;A(18,8)=1;A(18,11)=-1; % row 17 & 18
k=1:6;B(k+12)=Vbe(k);
for n=1:4
	C=A\B;
	for k=1:6
		Vben(k)=log(1+((1+Be)*C(k+12)/Is))/U; % Vbe refinement
		B(k+12)=Vben(k);
	end
end
y=(C(10)-C(11))/(E1-E2); % output gain in V/V
