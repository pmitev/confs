#!/bin/awk -f
# Author Pavlin Mitev 
# Version 2015.11.10
BEGIN{
  ss="H,He,Li,Be,B,C,N,O,F,Ne,Na,Mg,Al,Si,P,S,Cl,Ar,K,Ca,Sc,Ti,V,Cr,Mn,Fe,Co,Ni,Cu,Zn,Ga,Ge,As,Se,Br,Kr,Rb,Sr,Y,Zr,Nb,Mo,Tc,Ru,Rh,Pd,Ag,Cd,In,Sn,Sb,Te,I,Xe,Cs,Ba,La,Ce,Pr,Nd,Pm,Sm,Eu,Gd,Tb,Dy,Ho,Er,Tm,Yb,Lu,Hf,Ta,W,Re,Os,Ir,Pt,Au,Hg,Tl,Pb,Bi,Po,At,Rn,Fr,Ra,Ac,Th,Pa,U,Np,Pu,Am,Cm,Bk,Cf,Es,Fm,Md,No,Lr,Rf,Ha,D"
  split(ss,atsym,",")
  outf=1 # Default output format  
  orient[0]= "Input orientation"
  orient[1]= "Standard orientation"
  orient[2]= "Z-MATRIX (ANGSTROMS AND DEGREES)"
}

/Variables:/ {
  getline;  
  
  iv=0
  do {
    iv++
    Vname[iv]=$1
    getline;
  } while (NF==2)
}

/Stationary point found/{
  SP= 1; # found stationary point
  SPtxt= " -Stationary point- " # add info to the second line
}

$0 ~ orient[outf] && (SP < 2) {
  if (SP==1) SP= 2 # stop looking for geometry output

  getline; getline; getline; getline; getline;

  iat= 0
  do {
    iat++
    atn[iat]=$2; x[iat]=$4; y[iat]=$5; z[iat]=$6 
    getline;  
  } while (NF !=1) 
  
}


/Z-MATRIX \(ANGSTROMS AND DEGREES\)/{
  getline; getline; getline;
  
  iz=0
  do {
    iz++
    gsub(/\(|\)/," ",$0); 
    Zline[iz]= " "$3"  "$4"  "Vname[$6]"  "$7"  "Vname[$9]"  "$10"  "Vname[$12]"  "$13
    Vval[$6]= $5;    Vval[$9]= $8;    Vval[$12]= $11
    getline
  } while (NF !=1)

}

END{
  if (outf <= 1) {
    
    print iat"\n  XYZ "SPtxt"["orient[outf]"]  extracted from: "FILENAME
    for (i=1;i<=iat;i++) printf ("%4s  %14.8f  %14.8f  %14.8f\n",atsym[atn[i]],x[i],y[i],z[i])

  } else {
    
    for (i=1;i<=iz;i++) print Zline[i]
    print ""
    for (i=1;i<=iv;i++) print "   "Vname[i]"   "Vval[i]
    print ""
  }
}
