#!/usr/bin/awk -f 
BEGIN {
  ss="H,He,Li,Be,B,C,N,O,F,Ne,Na,Mg,Al,Si,P,S,Cl,Ar,K,Ca,Sc,Ti,V,Cr,Mn,Fe,Co,Ni,Cu,Zn,Ga,Ge,As,Se,Br,Kr,Rb,Sr,Y,Zr,Nb,Mo,Tc,Ru,Rh,Pd,Ag,Cd,In,Sn,Sb,Te,I,Xe,Cs,Ba,La,Ce,Pr,Nd,Pm,Sm,Eu,Gd,Tb,Dy,Ho,Er,Tm,Yb,Lu,Hf,Ta,W,Re,Os,Ir,Pt,Au,Hg,Tl,Pb,Bi,Po,At,Rn,Fr,Ra,Ac,Th,Pa,U,Np,Pu,Am,Cm,Bk,Cf,Es,Fm,Md,No,Lr,Rf,Ha,D"
  split(ss,atsym,",")
  for (j in atsym) atnmr[atsym[j]]=j
  for (j in atsym) atnmrl[tolower(atsym[j])]=j

  cmd="head -1 "ARGV[1]; cmd |& getline; natoms=$1; close(cmd);
  cmd="wc "ARGV[1]; cmd |& getline; lines=$1; close(cmd);

  frames=lines/(natoms+2); print frames;
}

{
 if (NF==1) {i=0; f++;
   printf"\rframe:"f > "/dev/stderr"; 
   print 
 }
  
 if (NF == 4) { 
   i++
   sub(/[[:digit:]].*/,"",$1); 
   printf"%4i %8.4f  %8.4f  %8.4f %3i\n",i,$2,$3,$4,atnmrl[tolower($1)] 
 }
}

END{print "" > "/dev/stderr"}
