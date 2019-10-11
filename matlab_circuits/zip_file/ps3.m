function dydt=ps3(t,v,flag,A,B)
% called by ODE function 
% Use vectorization
a=1:3;
vd(a)=A(a,1)*v(1)+A(a,2)*v(2)+A(a,3)*v(3)+B(a);
dydt=vd';
