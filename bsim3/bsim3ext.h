/**********
Copyright 1990 Regents of the University of California.  All rights reserved.
Author: 1991 JianHui Huang and Min-Chie Jeng.
Modified by Yuhua Cheng to use BSIM3v3 in Spice3f5 (Jan. 1997)
File: bsim3ext.h
**********/

#include "modelcard.h"
#include "modelins.h"
#include "spmatrix.h"
#include "err_code.h"

extern ERR_CODE NIintegrate(BSIM3instance *, double , double *, double *, double , int );
//extern int BSIM3acLoad(GENmodel *,CKTcircuit*);
//extern int BSIM3ask(CKTcircuit *,GENinstance*,int,IFvalue*,IFvalue*);
//extern int BSIM3convTest(GENmodel *,CKTcircuit*);
//extern int BSIM3delete(GENmodel*,IFuid,GENinstance**);
//extern void BSIM3destroy(GENmodel**);
//extern int BSIM3getic(GENmodel*,CKTcircuit*);
extern int BSIM3load(ModelInstance *, double *, double *, double *, double, int); 
//extern int BSIM3mAsk(CKTcircuit*,GENmodel *,int, IFvalue*);
//extern int BSIM3mDelete(GENmodel**,IFuid,GENmodel*);

//extern int BSIM3mParam(int,IFvalue*,GENmodel*);
extern int BSIM3mParam(int, double, BSIM3model *);
extern int BSIM3checkModel(BSIM3model*, BSIM3instance*);

//extern void BSIM3mosCap(CKTcircuit*, double, double, double, double,
//        double, double, double, double, double, double, double,
//        double, double, double, double, double, double, double*,
//        double*, double*, double*, double*, double*, double*, double*,
//        double*, double*, double*, double*, double*, double*, double*, 
//        double*);
//extern int BSIM3param(int,IFvalue*,GENinstance*,IFvalue*);

extern int BSIM3param(int, double, BSIM3instance *);

//extern int BSIM3pzLoad(GENmodel*,CKTcircuit*,SPcomplex*);
//extern int BSIM3setup(SMPmatrix*,GENmodel*,CKTcircuit*,int*);

extern int BSIM3ModelSetup(ModelCard *);
extern int BSIM3InstanceSetup(ModelInstance *, SPMatrix *, SPMatrix *, SPMatrix *, SPMatrix *);

extern int BSIM3temp(ModelInstance *, double);
//extern int BSIM3trunc(GENmodel*,CKTcircuit*,double*);
//extern int BSIM3noise(int,int,GENmodel*,CKTcircuit*,Ndata*,double*);
//extern int BSIM3unsetup(GENmodel*,CKTcircuit*);
