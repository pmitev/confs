#!/bin/awk -f
BEGIN{
  ss="H,He,Li,Be,B,C,N,O,F,Ne,Na,Mg,Al,Si,P,S,Cl,Ar,K,Ca,Sc,Ti,V,Cr,Mn,Fe,Co,Ni,Cu,Zn,Ga,Ge,As,Se,Br,Kr,Rb,Sr,Y,Zr,Nb,Mo,Tc,Ru,Rh,Pd,Ag,Cd,In,Sn,Sb,Te,I,Xe,Cs,Ba,La,Ce,Pr,Nd,Pm,Sm,Eu,Gd,Tb,Dy,Ho,Er,Tm,Yb,Lu,Hf,Ta,W,Re,Os,Ir,Pt,Au,Hg,Tl,Pb,Bi,Po,At,Rn,Fr,Ra,Ac,Th,Pa,U,Np,Pu,Am,Cm,Bk,Cf,Es,Fm,Md,No,Lr,Rf,Ha,D"
  split(ss,atsym,",")
  ms="1.00794,4.002602,6.941,9.012182,10.811,12.0107,14.0067,15.9994,18.9984032,20.1797,22.989770,24.3050,26.981538,28.0855,30.973761,32.065,35.453,39.948,39.0983,40.078,44.955910,47.867,50.9415,51.9961,54.938049,55.845,58.933200,58.6934,63.546,65.39,69.723,72.64,74.92160,78.96,79.904,83.80,85.4678,87.62,88.90585,91.224,92.90638,95.94,98,101.07,102.90550,106.42,107.8682,112.411,114.818,118.710,121.760,127.60,126.90447,131.293,132.90545,137.327,138.9055,140.116,140.90765,144.24,145,150.36,151.964,157.25,158.92534,162.50,164.93032,167.259,168.93421,173.04,174.967,178.49,180.9479,183.84,186.207,190.23,192.217,195.078,196.96655,200.59,204.3833,207.2,208.98038,208.98,209.99,222.02,223.02,226.03,227.03,232.0381,231.03588,238.02891,237.05,244.06,243.06,247.07,247.07,251.08,252.08,257.10,258.10,259.10,262.11,261.11,262.11,266.12,264.12,269.13,268.14,271.15,272.15,277,0,285,0,289,0,293"
  split(ms,atmass,",")
  for (j in atsym) atnmr[atsym[j]]=j
  
  atmu= 1.6605387e-27  # kg

  for(i=2;i<=ARGC;i++){typeT[i-1]=ARGV[i];}
  ARGC=2;

}


/ions per type =/{
  for(i=5;i<=NF;i++){ntype[i-4]=$i;natoms=natoms+$i}
  ntypes=NF-4
}


/   POTIM  =/{dt=2*$3} # time for 2 steps

/length of vectors/ {getline; a=$1; b=$2; c=$3;}

/POSITION                                       TOTAL-FORCE/{
  
  step++; k=0; getline;
  for(t=1;t<=ntypes;t++){
    
#    mass[t]=atmass[typeT[t]]*atmu; 
    
    for(i=1;i<=ntype[t];i++){
      k++
      getline; 

      x=$1; y=$2; z=$3;
      
      if (step==1) {xold[k]=x; yold[k]=y; zold[k]=z;}

      if (xold[k]-x < -.7*a) x=x-a
      if (xold[k]-x >  .7*a) x=x+a
      if (yold[k]-y < -.7*b) y=y-b
      if (yold[k]-y >  .7*b) y=y+b
      if (zold[k]-z < -.7*c) z=z-c
      if (zold[k]-z >  .7*c) z=z+c

#      printf "HETATM%5i%4s%9s1    %8.3f%8.3f%8.3f%6.2f\n",k,typeT[t],ls,x,y,z,1;

      if (step>=3){
        xvb=(x-xbb[k])/dt; yvb=(y-ybb[k])/dt; zvb=(z-zbb[k])/dt;
        vb=sqrt(xvb**2 + yvb**2 + zvb**2)
        print k,x,y,z,xvb,yvb,zvb,vb
      }
      
      xold[k]=x; yold[k]=y; zold[k]=z;

      xbb[k]=xb[k];  ybb[k]=yb[k];  zbb[k]=zb[k]
      xb[k]=xold[k]; yb[k]=yold[k]; zb[k]=zold[k]
      

      
    }
  }
}
