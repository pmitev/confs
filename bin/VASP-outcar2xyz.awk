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
  for(i=2;i<=ARGC;i++){typeT[i-1]=ARGV[i];}
  ARGC=2;

#  cmd="grep POSITION "ARGV[1]" | wc"; cmd |& getline; steps=$1; close(cmd); print steps
  cmd="head -300| grep 'number of ions     NIONS' "ARGV[1]; cmd |& getline; nions=$12; close(cmd); 
}

/TITEL/{
  ti++
  if (!typeT[ti]) {
    sub("_.*$","",$4);
    typeT[ti]=$4;
  }
}

/ions per type =/{
  for(i=5;i<=NF;i++){ntype[i-4]=$i;}
  ntypes=NF-4
}

/direct lattice vectors                 reciprocal lattice vectors/{
  getline; h1[1]=$1; h1[2]=$2; h1[3]=$3;
  getline; h2[1]=$1; h2[2]=$2; h2[3]=$3;
  getline; h3[1]=$1; h3[2]=$2; h3[3]=$3;
  #print norm(h1),norm(h2),norm(h3);
  alpha= angle(h2,h3); beta= angle(h1,h3); gamma= angle(h1,h2);
}

/length of vectors/{
  getline; a=$1; b=$2; c=$3; 
}

/POSITION                                       TOTAL-FORCE/{
  getline;
  print nions 
  if(!jmolscriptline) {
   print "jmolscript: load \"\" {1 1 1} unitcell {"a,b,c, alpha, beta, gamma"}; rotate x -90; animation mode loop;  animation on; frame 1;"
   jmolscriptline=1;
  }else { print "label"}
  for(t=1;t<=ntypes;t++){
    for(i=1;i<=ntype[t];i++){
      getline; print typeT[t],$1,$2,$3
    }
  }
}
