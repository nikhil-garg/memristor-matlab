*INV for trace the correctness of matlab model
.include 'tsmc90.spice3'
*.option trtol=1
*.option chgtol=1.0e-17
*.option abstol=1.0e-9
*.option reltol=1.0e-9
*.option volttol=1.0e-9

.param r1 = 10m;
.param rv = 1;
.param c1 = 1f;
.param l1 = 1p

*node number is re-arranged in the internal sparse matrix 
*where the node number is not necessary the same here
m1 2 1 3 3 pch1 w=2u l=100n nrd=0 nrs=0
m2 2 1 0 0 nch1 w=1u l=100n nrd=0 nrs=0
Rv1 3 0 'rv'
R1 2 7 'r1'
C1 4 0 'c1'
R2 5 6 'r1'
Rv 5 0 'rv'
**for MEXP case
C2 1 0 'c1'
C3 2 0 'c1'
C4 3 0 'c1'
C5 5 0 'c1'
**for IND case
L1 6 1 'l1'
L2 7 4 'l1'



Isupply 0 3 1
Iinput 0 5 pwl (0 0 500p 0 600p 1 1n 1)

.tran 10p 1n

.print tran v(4) v(3)

.end
