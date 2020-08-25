#!/bin/awk -f
BEGIN{
  boxl= 19.838590859539682
  chg["O"]= 6
  chg["H"]= 1
  chg["X"]= -2 
}

NF==1 {
  natoms= $1
  getline; CHGsum=0; Dx= 0; Dy= 0; Dz= 0;
  for (i=1;i<=natoms;i++){
    getline;
    # Put everything back in the box
    x= $2%boxl; if (x< .0 ) x=x+boxl; xf=x/boxl;
    y= $3%boxl; if (y< .0 ) y=y+boxl; yf=y/boxl;
    z= $4%boxl; if (z< .0 ) z=z+boxl; zf=z/boxl;
    CHG= chg[$1];

    CHGsum= CHGsum + CHG
    Dx= Dx + x*CHG;  Dy= Dy + y*CHG;   Dz= Dz + z*CHG;
  }
  print CHGsum,Dx*4.80320425,Dy*4.80320425,Dz*4.80320425
}

