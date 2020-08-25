#!/usr/bin/awk -f 
BEGIN {
  ss="H,He,Li,Be,B,C,N,O,F,Ne,Na,Mg,Al,Si,P,S,Cl,Ar,K,Ca,Sc,Ti,V,Cr,Mn,Fe,Co,Ni,Cu,Zn,Ga,Ge,As,Se,Br,Kr,Rb,Sr,Y,Zr,Nb,Mo,Tc,Ru,Rh,Pd,Ag,Cd,In,Sn,Sb,Te,I,Xe,Cs,Ba,La,Ce,Pr,Nd,Pm,Sm,Eu,Gd,Tb,Dy,Ho,Er,Tm,Yb,Lu,Hf,Ta,W,Re,Os,Ir,Pt,Au,Hg,Tl,Pb,Bi,Po,At,Rn,Fr,Ra,Ac,Th,Pa,U,Np,Pu,Am,Cm,Bk,Cf,Es,Fm,Md,No,Lr,Rf,Ha,D"
  split(ss,atsym,",")
  for (j in atsym) atnmr[atsym[j]]=j
  #print atsym[8]
  #print atnmr["Ti"]}
  au2a=0.52917721;
}

#---------------------------------------------------------------------------
/length of vectors/ {getline; a=$1; b=$2; c=$3}

/POSITION                                       TOTAL-FORCE/ { getline; getline;
  l=0;steps++
  while(NF==6){
    x=$1; y=$2; z=$3;
    l++
    if (steps==1) {xold[l]=x; yold[l]=y; zold[l]=z;}

    if (xold[l]-x < -.7*a) x=x-a
    if (xold[l]-x >  .7*a) x=x+a
    if (yold[l]-y < -.7*b) y=y-b
    if (yold[l]-y >  .7*b) y=y+b
    if (zold[l]-z < -.7*c) z=z-c
    if (zold[l]-z >  .7*c) z=z+c
    
    xsum[l]=xsum[l]+x; ysum[l]=ysum[l]+y; zsum[l]=zsum[l]+z;
      
    xold[l]=x; yold[l]=y; zold[l]=z;
    getline 
  }
  if (natoms < l) natoms=l
}
#---------------------------------------------------------------------------
END{
  print "# " steps,natoms >> "imsd.dat";
  print "# <timestep> <imsd atom1 [A^2]> <> ...." >> "imsd.dat";

  for (l=1;l<=natoms;l++) {
    xmean[l]=xsum[l]/steps; ymean[l]=ysum[l]/steps; zmean[l]=zsum[l]/steps;
  }
 
  steps=0;
  while ((getline < ARGV[1]) > 0 ) {
    if($0~"length of vectors") { getline < ARGV[1]; a=$1; b=$2; c=$3;}

    if($0~"POSITION                                       TOTAL-FORCE"){ 
      getline< ARGV[1]; getline< ARGV[1];

      l=0;steps++; 
      printf steps >> "imsd_x.dat" ;
      printf steps >> "imsd_y.dat" ;
      printf steps >> "imsd_z.dat" ;
      printf steps >> "imsd.dat" ;
      while(NF==6){
        x=$1; y=$2; z=$3;
        l++; 
        if (steps==1) {xold[l]=x; yold[l]=y; zold[l]=z;}
    
        if (xold[l]-x < -.7*a) x=x-a
        if (xold[l]-x >  .7*a) x=x+a
        if (yold[l]-y < -.7*b) y=y-b
        if (yold[l]-y >  .7*b) y=y+b
        if (zold[l]-z < -.7*c) z=z-c
        if (zold[l]-z >  .7*c) z=z+c
        
        dx2=(xmean[l]-x)**2; dy2=(ymean[l]-y)**2; dz2=(zmean[l]-z)**2
        
        # To get results for the Debye-Waller factor
#       dr=(dx2 + dy2 + dz2)/3.

        # To get imsd 
        
        dr= dx2 + dy2 + dz2
        
        printf" %g",dx2 >> "imsd_x.dat"
        printf" %g",dy2 >> "imsd_y.dat"
        printf" %g",dz2 >> "imsd_z.dat"
        printf" %g",dr >> "imsd.dat"
          
        xold[l]=x; yold[l]=y; zold[l]=z;
        getline < ARGV[1];
      }
      print"" >> "imsd_x.dat"; print"" >> "imsd_y.dat"; print"" >> "imsd_z.dat"; print"" >> "imsd.dat";
    } 
  }
  close(ARGV[1]); 
}
