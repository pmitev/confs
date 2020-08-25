#!/bin/awk -f
BEGIN{
  vscale=1.;
  pi=3.14159265358979;rad2deg=180./pi;

  for(i=2;i<=ARGC;i++){typeT[i-1]=ARGV[i];}
  ARGC=2;
  cmd="head -n 5000 "ARGV[1]"| grep 'number of ions     NIONS' "; cmd |& getline; nions=$12; close(cmd);
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
  j=0;
  for(t=1;t<=ntypes;t++){
    for(i=1;i<=ntype[t];i++){
      j++
      #getline; print typeT[t],$1,$2,$3
      at[j]=typeT[t]; x[j]=$1; y[j]=$2; z[j]=$3;
    }
  }
}

#/Eigenvectors after division by SQRT/{lprint=1}

/Eigenvectors and eigenvalues of the dynamical matrix/{
  getline;getline; getline; getline; 
  while ($1 != "Finite") {
    print nions
    if(!jmolscriptline) {
      print "jmolscript: load 1.xyz {1 1 1} unitcell {"a,b,c, alpha, beta, gamma"}; "
      jmolscriptline=1;
    } else     print "FREQ N "$1,$8"  cm-1 A IRint 0 RAMAN_int 10"
    getline;getline;j=0
    while (NF>1){
      j++
      print at[j],$1,$2,$3,0, $4*vscale,$5*vscale,$6*vscale
      getline; 
    }
  getline; 
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


## load.spt template
#load "1.xyz" {1 1 1} unitcell {3.180833960  3.180833960  4.767895258 90 90 120}
#vibration off;
#wireframe .1;  set PerspectiveDepth false;
##vectors on; vector scale 7; color vectors white;
#rotate x -80; rotate y 8;
#delay 1;
##vibration on;
