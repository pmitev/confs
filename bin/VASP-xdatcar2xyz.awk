#!/bin/awk -f
BEGIN{
  pi=3.14159265358979;rad2deg=180./pi;
  for(i=2;i<=ARGC;i++){typeT[i-1]=ARGV[i];}
  ARGC=2;

  getline; titel=$0
  getline; s=$1
  getline; h1[1]=$1*s; h1[2]=$2*s; h1[3]=$3*s;
  getline; h2[1]=$1*s; h2[2]=$2*s; h2[3]=$3*s;
  getline; h3[1]=$1*s; h3[2]=$2*s; h3[3]=$3*s;
  a= norm(h1);  b= norm(h2);  c= norm(h3);
  alpha= angle(h2,h3); beta= angle(h1,h3); gamma= angle(h1,h2);

  getline; ntypes=NF; for(i=1;i<=NF;i++){typeT[i]=$i;}
  getline; for(i=1;i<=NF;i++){ntype[i]=$i;nions+= $i}
}


/Direct configuration/{
  print " "nions 
  if(!jmolscriptline) {
    print "jmolscript: load \"\" {1 1 1} unitcell {"a,b,c, alpha, beta, gamma"}; rotate x -90; animation mode loop;  animation on; frame 1;"
    jmolscriptline=1;
  }else { print "XYZ"}
  for(t=1;t<=ntypes;t++){
    for(i=1;i<=ntype[t];i++){
      getline
      x=$1*h1[1]+$1*h2[1]+$1*h3[1]
      y=$2*h1[2]+$2*h2[2]+$2*h3[2]
      z=$3*h1[3]+$3*h2[3]+$3*h3[3]
      print typeT[t],x,y,z
    }
  }
}

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
