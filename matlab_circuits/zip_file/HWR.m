function y=HWR(V1,w,t,T)
% half-wave rectified sine wave
% 0 from 0 to pi
% negative from pi to 2pi
% t is modulo T
if t < T/2
	y=0;
else
	y=2*V1*sin(w*t);
end
