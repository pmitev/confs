#!/bin/awk -f
function asin(a)       { return atan2(a,sqrt(1-a*a)) }
function acos(a)       { return pi/2-asin(a) }
function norm(x)       {return (sqrt(x[1]*x[1]+x[2]*x[2]+x[3]*x[3]));}
function dotprod (x,y) {return ( x[1]*y[1] + x[2]*y[2] + x[3]*y[3] );}
function angle (v1,v2) {
  myacos = dotprod(v1,v2)/norm(v1)/norm(v2);
  if (myacos>1.0) myacos = 1.0;
  if (myacos<-1.0) myacos = -1.0;
  return(acos(myacos)*180.0/3.14159265358979);
}

BEGIN{
  pi=3.14159265358979;rad2deg=180./pi;
  if(ARGC<=1) { print "Syntax: \n      VASP-poscar2res.awk  POSCAR [type1] [type2] ..."; ex=1;exit}
  for(i=2;i<=ARGC;i++){typeT[i-1]=ARGV[i];}
    ARGC=2;
    
  getline; title=$0
  getline; scale=$1
  getline; h1[1]=$1*scale; h1[2]=$2*scale; h1[3]=$3*scale;
  getline; h2[1]=$1*scale; h2[2]=$2*scale; h2[3]=$3*scale;
  getline; h3[1]=$1*scale; h3[2]=$2*scale; h3[3]=$3*scale;

  a=norm(h1); b=norm(h2); c=norm(h3);
  alpha= angle(h2,h3); beta= angle(h1,h3); gamma= angle(h1,h2);
  

  getline; 
  # check for labels 
  if ($1*1 != $1) {
    for(i=1;i<=NF;i++){typeT[i]=$i;}
    getline;
  }

  for(i=1;i<=NF;i++) {type[i]=$i; natoms=natoms+$i} ntypes=NF;


  while(($0 !~ "Direct")&&($0 !~ "Cart")) getline;

  if ($0 ~ "Direct") fractional=1
  
  print natoms
  print "#jmolscript: load 1.xyz {1 1 1} unitcell {"a,b,c, alpha, beta, gamma"}; rotate x -90; animation mode loop;  animation on; frame 1;" 
  for(k=1;k<=ntypes;k++){
    for(i=1;i<=type[k];i++){
      getline
      if (fractional){
        xx=$1*h1[1]+$2*h2[1]+$3*h3[1];
        yy=$1*h1[2]+$2*h2[2]+$3*h3[2];
        zz=$1*h1[3]+$2*h2[3]+$3*h3[3];
        printf"%-4s%s%7f %7f %7f\n", typeT[k],"  ",xx,yy,zz
      } else {
        printf"%-4s%s%7f %7f %7f\n", typeT[k],"  "  ,$1,$2,$3
      }
    }
  }

}
