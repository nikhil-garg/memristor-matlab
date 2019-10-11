function y=ccs(R1,R2,R3,Be,E3)
% constant current sources for uA733
Vd=0.6;Is=3e-12;U=30.5;
A=[1/R1 0 0 1 1;
	0 1 0 -R2 0;
	0 0 1 0 -(1+Be)*R3;
	1 0 -1 0 0;
	1 -1 0 0 0];
for n=1:4
	B=[E3/R1;0;0;Vd;Vd];
	C=A\B;
	Ie=(1+Be)*C(5);
	Vd=log(1+Ie/Is)/U;
end
y=Ie;
