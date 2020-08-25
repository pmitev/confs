#!/usr/bin/awk -f 
BEGIN {print 1;}
/Number of irreducible atoms/ {print $6}
/Final charges from QEq :/ {ch=1}
/Coordinates and initial charges of atoms :/ {cor=1}
/Cartesian coordinates of cluster :/ {cor=1}
{

  if ((NF == 8) && ($3 == "c") && (cor==1)) {
  ix++; x[ix]=$4; y[ix]=$5; z[ix]=$6;
  }
  
  if ((NF == 3) && ($1 ~ "[0-9]") && (ch==1) ){
    il++; lab[il]=$3; t[il]=$2;
  }

}

END {
 for (l=1; l <=ix; l++) print " "lab[l]"    ",x[l],y[l],z[l],t[l]
}
