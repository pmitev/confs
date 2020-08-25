/*
I wrote `histogram.c' as a part of my effort to contribute
to a paper by two of my colleagues at SMU. The paper
discussed various programming environments such as Gnuplot,
awk, spice, and xfig.  It was tested in a BSD Unix environment.

This program is especially useful to plot histograms of data
in a file by a sequence of commands in gnuplot such as:

     !histogram 50 > tmp < datain
     plot "tmp" with impulses
Mustafa Kocaturk    mustafa@seas.smu.edu  EE Dept., SEAS, SMU
*/
#include <stdio.h>
#include <math.h>
#define HELP \
"This program calculates the histogram of a sequence of numbers\n\
read from the standard input until an end of file is encountered.\n\
The results are printed on the standard output as lines of the format\n\
<subinterval midpoint> <number of sample points in subinterval>\n\
\n\
Usage: %s [number of subintervals (default==100)]\n" /* Message string */

#define CALSIZ 50000 /* Number of doubles to be allocated for sort */

main(argc,argv)
 int argc;
 char **argv;
 {
 double x,t,z,*a,*b,*f,*fe,*fl;
 unsigned i=0,k=100;
 int j=1;
 char c;
 if(argc>1)j=sscanf(argv[1],"%u",&k);
 if(j!=1){fprintf(stderr,HELP,argv[0]);return 0;}
 if(NULL==(a=(double *)calloc(CALSIZ,sizeof x)))
  {
  fprintf(stderr,"%s: Unable to allocate memory\n",(argv[0]));
  return 0; /* let other work continue */
  }
 fl=a+CALSIZ-1;
 fe=a;
 b=a+1;
 for(i=0;j>0&&fe<fl;)
  {
  if((j=scanf("%lf%*[^\n]%*c",&x))>0) /* If number was recognized */
   {
   f=fe++;
   while(x<*f&&f>a) { f[1]=*f; f--; }
   f[1]=x;
   i++;
   }
  else
   j=scanf("%*[^\n]%*c");
   /* Read data until end-of-line,
   if end-of-stdin (i. e. ctrl-D) then j<0 (i. e. break the for loop) */
  }
 x=*b; /* This was Insertion sort (increasing) */
 t=*fe;
 printf("# %d points in [%lg, %lg]; Frequencies in %d subintervals:\n",i,x,t,k);
 t=(t-x)/k;
 x+=t;
 for(f=b,i=0;i<k;i++,x+=t)
  {
  for(j=0;x>*f&&f<=fe;j++,f++);/* Count points in the subinterval */
  printf(" %lg %d\n",x-t*.5,j); /* Print subinterval center and
   number of points in the subinterval to stdout */
  }
 }
