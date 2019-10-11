/**** BSIM3v3.3.0, Released by Xuemei Xi 07/29/2005 ****/

/**********
 * Copyright 2004 Regents of the University of California. All rights reserved.
 * File: b3par.c of BSIM3v3.3.0
 * Author: 1995 Min-Chie Jeng and Mansun Chan
 * Author: 1997-1999 Weidong Liu.
 * Author: 2001 Xuemei Xi
 **********/

//#include "ngspice.h"
//#include "ifsim.h"
#include "bsim3def.h"

#include "err_code.h"
#include "util.h"
#include "const.h"
//#include "sperror.h"
//#include "suffix.h"
//#include "fteext.h"

int
BSIM3param (
int param,
//IFvalue *value,
double value,
BSIM3instance *model
//GENinstance *inst,
//IFvalue *select)
)
{
    double scale;

    //BSIM3instance *here = (BSIM3instance*)inst;
    BSIM3instance *here = model;

    //if ( !cp_getvar( "scale", CP_REAL, (double*) &scale ) ) scale = 1;
    scale = 1;

    switch(param) 
    {   
	case BSIM3_W:
            here->BSIM3w = value*scale;
            here->BSIM3wGiven = TRUE;
            break;
        case BSIM3_L:
            here->BSIM3l = value*scale;
            here->BSIM3lGiven = TRUE;
            break;
	case BSIM3_M:
	    here->BSIM3m = value;
	    here->BSIM3mGiven = TRUE;
	    break;
        case BSIM3_AS:
            here->BSIM3sourceArea = value*scale*scale;
            here->BSIM3sourceAreaGiven = TRUE;
            break;
        case BSIM3_AD:
            here->BSIM3drainArea = value*scale*scale;
            here->BSIM3drainAreaGiven = TRUE;
            break;
        case BSIM3_PS:
            here->BSIM3sourcePerimeter = value*scale;
            here->BSIM3sourcePerimeterGiven = TRUE;
            break;
        case BSIM3_PD:
            here->BSIM3drainPerimeter = value*scale;
            here->BSIM3drainPerimeterGiven = TRUE;
            break;
        case BSIM3_NRS:
            here->BSIM3sourceSquares = value;
            here->BSIM3sourceSquaresGiven = TRUE;
            break;
        case BSIM3_NRD:
            here->BSIM3drainSquares = value;
            here->BSIM3drainSquaresGiven = TRUE;
            break;
        case BSIM3_OFF:
            here->BSIM3off = (int)value;
            break;
        case BSIM3_IC_VBS:
            here->BSIM3icVBS = value;
            here->BSIM3icVBSGiven = TRUE;
            break;
        case BSIM3_IC_VDS:
            here->BSIM3icVDS = value;
            here->BSIM3icVDSGiven = TRUE;
            break;
        case BSIM3_IC_VGS:
            here->BSIM3icVGS = value;
            here->BSIM3icVGSGiven = TRUE;
            break;
        case BSIM3_NQSMOD:
            here->BSIM3nqsMod = (int)value;
            here->BSIM3nqsModGiven = TRUE;
            break;
        case BSIM3_ACNQSMOD:
            here->BSIM3acnqsMod = (int)value;
            here->BSIM3acnqsModGiven = TRUE;
            break;
        case BSIM3_IC:
            //switch(value->v.numValue)
	    //{
            //    case 3:
            //        here->BSIM3icVBS = *(value->v.vec.rVec+2);
            //        here->BSIM3icVBSGiven = TRUE;
            //    case 2:
            //        here->BSIM3icVGS = *(value->v.vec.rVec+1);
            //        here->BSIM3icVGSGiven = TRUE;
            //    case 1:
            //        here->BSIM3icVDS = *(value->v.vec.rVec);
            //        here->BSIM3icVDSGiven = TRUE;
            //        break;
            //    default:
            //        return(E_BADPARM);
            //}
            //break;
        default:
            return(ERR_BAD_PARAMETER);
    }
    return(ERR_OK);
}



