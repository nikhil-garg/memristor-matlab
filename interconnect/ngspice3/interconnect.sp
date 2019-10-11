*INTERCONNECT for comparing the correctness of matlab model 
.include '90nm_bulk.pm'

.param r1 = 10m;
.param rv = 1;
.param c1 = 1f;
.param l1 = 1p;

Rv1 1 0 'rv'
Rv2 4 0 'rv'
R1 1 5 'r1'
R2 2 6 'r1'
R3 3 7 'r1'
L1 5 2 'l1'
L2 6 3 'l1'
L3 7 4 'l1'
C1 1 0 'c1'
C2 2 0 'c1'
C3 3 0 'c1'
C4 4 0 'c1'

*Iinput 0 1 pwl (0 0 500p 0 600p 1 1n 1)

Iinput 0 1 pwl (0 0 10f 0 20f 1 10p 1)

.tran 1f 1p

.print tran v(4) v(1) v(2)

.end
