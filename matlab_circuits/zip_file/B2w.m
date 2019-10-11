function y = B2w(R1,R2,R3,C1,C2,w)
% function for MFBPF
% magnitude function only - faster
N1=1/(R1*C2);
D1=(1/C1+1/C2)/R3;
D0=(1/R1+1/R2)/(R3*C1*C2);
y=N1*w/sqrt((D0-w^2)^2+(D1*w)^2);
