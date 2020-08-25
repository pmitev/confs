#!/usr/bin/awk -f
BEGIN{

  ntypes=ARGC-2;
  for(i=2;i<=ARGC;i++){typeT[i-1]=ARGV[i];}
  ARGC=2;i=0;
}

/name/ {label=$2" "$3" "$4" "$5" "$6;
  print label;
  print "   1.00000000000000";
}

/vect/ {
                  getline; h[1]=$1; h[2]=$2; h[3]=$3; print "   "$0; DIM=NF; 
  if (DIM >= 2)  {getline; h[4]=$1; h[5]=$2; h[6]=$3; print "   "$0;}
  if (DIM == 3)  {getline; h[7]=$1; h[8]=$2; h[9]=$3; print "   "$0;}

}

/frac/ {frac=1}


$2=="core" && $3*1.==$3 && $4*1.==$4 && $5*1.==$5 {
  i++;  type[$1]++
   atl[i]=$1; atx[i]=$3; aty[i]=$4; atz[i]=$5; 
  natoms=i;
}

END{
  for (i=1;i<= ntypes;i++){
    typelabels= typelabels typeT[i]"  "  
    typenum=    typenum type[typeT[i]]"  "
  }
  print "   "typelabels
  print "   "typenum
  if(frac) {print "Direct"} else {print "Cartesian"}
  
  for (i=1;i<= ntypes;i++){
    for (k=1;k<=natoms;k++){
      if (atl[k]==typeT[i]) printf ("%20.16f %20.16f %20.16f\n",atx[k],aty[k],atz[k])
    }
  }

}

