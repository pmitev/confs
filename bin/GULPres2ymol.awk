#!/bin/awk -f
BEGIN { print 1;
ss="H,He,Li,Be,B,C,N,O,F,Ne,Na,Mg,Al,Si,P,S,Cl,Ar,K,Ca,Sc,Ti,V,Cr,Mn,Fe,Co,Ni,Cu,Zn,Ga,Ge,As,Se,Br,Kr,Rb,Sr,Y,Zr,Nb,Mo,Tc,Ru,Rh,Pd,Ag,Cd,In,Sn,Sb,Te,I,Xe,Cs,Ba,La,Ce,Pr,Nd,Pm,Sm,Eu,Gd,Tb,Dy,Ho,Er,Tm,Yb,Lu,Hf,Ta,W,Re,Os,Ir,Pt,Au,Hg,Tl,Pb,Bi,Po,At,Rn,Fr,Ra,Ac,Th,Pa,U,Np,Pu,Am,Cm,Bk,Cf,Es,Fm,Md,No,Lr,Rf,Ha,D"
split(ss,atsym,",")
for (j in atsym) atnmr[atsym[j]]=j
#print atsym[8]
#print atnmr["Ti"]
}  

{ if (coor) {
    if (i==0) prn=1
    if (prn) print $6,$3,$4,$5,atnmr[$1]
    if ((i>0) && (NF!=oldnf)) coor=0
    oldnf=NF; i++
  }
}
/cartesian/ {print $2; coor=1}


END {   
}

