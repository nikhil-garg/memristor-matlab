function y=simp3a(V,n)
% Simpon's 3/8 rule integration routine
% Ref:  Numerical Methods for Engineer's,
% Chapra & Canale, 3rd ed, p.600
% V is vector of function points
% 
% n is the number points in the function V
%
h=3/(8*n);teg=0;
c=4:3:n;
teg=teg+h*(V(c-3)+3*(V(c-2)+V(c-1))+V(c));
y=sum(teg);
