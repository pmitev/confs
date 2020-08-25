#!/bin/awk -f
BEGIN{

  ntypes=ARGC-2;
  for(i=2;i<=ARGC;i++){typeT[i-1]=ARGV[i];}
  ARGC=2;i=0;
}

/name/ {label=$2" "$3" "$4" "$5" "$6;
#  print label;
#  print "   1.00000000000000";
}

/vect/ {
                  getline; h[1]=$1; h[2]=$2; h[3]=$3; hl=$0; DIM=NF; 
  if (DIM >= 2)  {getline; h[4]=$1; h[5]=$2; h[6]=$3; hl=hl"\n"$0}
  if (DIM == 3)  {getline; h[7]=$1; h[8]=$2; h[9]=$3; hl=hl"\n"$0}

}

/frac/ {frac=1}


$2=="core" && $3*1.==$3 && $4*1.==$4 && $5*1.==$5 {
  i++;  type[$1]++
  atl[i]=$1; atx[i]=$3; aty[i]=$4; atz[i]=$5; 
  for (k=1;k<=ntypes;k++) {if ($1==typeT[k]) att[i]=k} 
  natoms=i;
}

END{
  printf natoms"  ";
  if ((DIM == 3) && (frac == 1)) print "F"; else print "S";
  for (i=1;i<= ntypes;i++){
    typelabels= typelabels typeT[i]"  "  
    typenum=    typenum type[typeT[i]]"  "
  }
  print typelabels
#  print typenum
#  if(frac) {print "Direct"} else {print "Cartesian"}

  for (i=1;i<= natoms;i++){
    printf ("%8i %2i  %10.6f %10.6f %10.6f\n",i,att[i], atx[i],aty[i],atz[i])
  }
  
  print " 0.000000  0.000000  0.000000\n"hl;
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

