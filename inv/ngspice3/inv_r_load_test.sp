*INV for trace the correctness of matlab model
.include 'tsmc90.spice3'
.option trtol=1
.option chgtol=1.0e-17
.option abstol=1.0e-9
.option reltol=1.0e-9
.option volttol=1.0e-9

.param r1 = 10m;
.param rv = 1;
.param c1 = 1f;
.param bigr = 1000000;

*node number is re-arranged in the internal sparse matrix 
*where the node number is not necessary the same here
m1 2 1 3 3 pch1 w=2u l=100n nrd=0 nrs=0
m2 2 1 0 0 nch1 w=1u l=100n nrd=0 nrs=0
Rv1 3 0 1 
R1 2 4 1e-2
C1 4 0 1e-15
R2 5 1 1e-2
Rv 5 0 1
**for MEXP case
C2 1 0 1e-15
C3 2 0  1e-15
C4 3 0  1e-15
C5 5 0  1e-15
Rbig 4 0 1000000



Isupply 0 3 1
Iinput 0 5 pwl (0 0 500p 0 600p 1 1n 1)

.tran 10p 1n

.print tran v(1) v(2) v(3) v(4) v(5)

.end
