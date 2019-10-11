#ifndef _DEVDEF_H_
#define _DEVDEF_H_

double DEVlimvds(double,double);
double DEVpnjlim(double,double,double,double,int*);
double DEVfetlim(double,double,double);
void DEVcmeyer(double,double,double,double,double,double,double,double,double,
	       double,double,double*,double*,double*,double,double,double,double);
void DEVqmeyer(double,double,double,double,double,double*,double*,double*, double,double);

#endif //_DEVDEF_H_
