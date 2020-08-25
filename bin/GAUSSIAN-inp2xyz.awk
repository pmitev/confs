#!/usr/bin/awk -f
BEGIN{print "single"}

/^#/ {
  if (natoms !=0){ printatoms() }
  natoms=0
}

{
  if (NF==4) {
    natoms++
    if ($1*1==0)     atomline[natoms]=$0
    if (int($1)==$1) atomline[natoms]=$0
    if (($1*1!=0) && (int($1)!=$1)) {atomline[natoms]="C  "$0} 
  }
}

END{
  printatoms()
}

#---------------------------------------------------------
function printatoms() {
  print natoms"\nXYZ"
  for (i=1;i<=natoms;i++){
    print atomline[i]
  } 
}

