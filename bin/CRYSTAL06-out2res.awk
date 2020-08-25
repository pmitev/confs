#!/usr/bin/awk -f


/DIRECT LATTICE VECTORS CARTESIAN COMPONENTS/{
  getline;
  getline; h[1]=$1; h[2]=$2; h[3]=$3
  getline; h[4]=$1; h[5]=$2; h[6]=$3
  getline; h[7]=$1; h[8]=$2; h[9]=$3
}

/LATTICE PARAMETERS.*ANGSTROM/{
  getline;getline;getline;
  if (NF==6){
    a=$1; b=$2; c=$3; alpha=$4; beta=$5; gamma=$6; print "conv"; 
    if (c==500) {
      dim=2; print "scell"; print "    "a,b,alpha; 
      print "sfractional"
    } else {
      dim=3; print "cell"; print "    "a,b,c,alpha,beta,gamma;
      print "fractional"
    }
  
  
    getline;getline;getline;getline;getline;
    while(NF>1){
      at[$1]=$4; an[$1]=$3; sxx[$1]=$5; syy[$1]=$6; szz[$1]=$7+0; 
      natoms=$1
      printf "%-4s   %16.12f   %16.12f   %16.12f\n", at[$1],sxx[$1],syy[$1],szz[$1]
      
      getline
    }
  }
  
}

