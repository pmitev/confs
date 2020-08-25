#!/usr/bin/awk -f
BEGIN{
  if(ARGC<=1) { print "Syntax: \n      VASP-poscar2res.awk  POSCAR type1 type2 ..."; ex=1;exit}
  for(i=2;i<=ARGC;i++){typeT[i-1]=ARGV[i];}
    ARGC=2;
    
  getline; title=$0
  print "prop conv"
  print ""
  print "name "title
  print ""
  
  getline; scale=$1
  
  print "vectors"
  getline; h[1]=$1; h[2]=$2; h[3]=$3; printf" %20.16f %20.16f %20.16f\n", $1*scale,$2*scale,$3*scale
  getline; h[4]=$1; h[5]=$2; h[6]=$3; printf" %20.16f %20.16f %20.16f\n", $1*scale,$2*scale,$3*scale
  getline; h[7]=$1; h[8]=$2; h[9]=$3; printf" %20.16f %20.16f %20.16f\n", $1*scale,$2*scale,$3*scale
  

  getline; 
  # check for labels 
  if ($1*1 != $1) {
    for(i=1;i<=NF;i++){typeT[i]=$i;}
    getline;
  }

  for(i=1;i<=NF;i++) {type[i]=$i;} ntypes=NF;

  while(($0 !~ "Direct")&&($0 !~ "Cart")) getline;

  if ($0 ~ "Direct") print "fractional"
  if ($0 ~ "Cart") print "cartesian"
  
  for(k=1;k<=ntypes;k++){
    for(i=1;i<=type[k];i++){
      getline; printf"%-4s%s%7f %7f %7f\n", typeT[k],"    core   ",$1,$2,$3
    }
  }

}
