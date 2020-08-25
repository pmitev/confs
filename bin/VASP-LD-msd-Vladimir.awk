#!/bin/awk -f
#Keywors to use "eigen phon"
BEGIN{
  ss="H,He,Li,Be,B,C,N,O,F,Ne,Na,Mg,Al,Si,P,S,Cl,Ar,K,Ca,Sc,Ti,V,Cr,Mn,Fe,Co,Ni,Cu,Zn,Ga,Ge,As,Se,Br,Kr,Rb,Sr,Y,Zr,Nb,Mo,Tc,Ru,Rh,Pd,Ag,Cd,In,Sn,Sb,Te,I,Xe,Cs,Ba,La,Ce,Pr,Nd,Pm,Sm,Eu,Gd,Tb,Dy,Ho,Er,Tm,Yb,Lu,Hf,Ta,W,Re,Os,Ir,Pt,Au,Hg,Tl,Pb,Bi,Po,At,Rn,Fr,Ra,Ac,Th,Pa,U,Np,Pu,Am,Cm,Bk,Cf,Es,Fm,Md,No,Lr,Rf,Ha,D"
  split(ss,atsym,",")
  ms="1.00794,4.002602,6.941,9.012182,10.811,12.0107,14.0067,15.9994,18.9984032,20.1797,22.989770,24.3050,26.981538,28.0855,30.973761,32.065,35.453,39.948,39.0983,40.078,44.955910,47.867,50.9415,51.9961,54.938049,55.845,58.933200,58.6934,63.546,65.39,69.723,72.64,74.92160,78.96,79.904,83.80,85.4678,87.62,88.90585,91.224,92.90638,95.94,98,101.07,102.90550,106.42,107.8682,112.411,114.818,118.710,121.760,127.60,126.90447,131.293,132.90545,137.327,138.9055,140.116,140.90765,144.24,145,150.36,151.964,157.25,158.92534,162.50,164.93032,167.259,168.93421,173.04,174.967,178.49,180.9479,183.84,186.207,190.23,192.217,195.078,196.96655,200.59,204.3833,207.2,208.98038,208.98,209.99,222.02,223.02,226.03,227.03,232.0381,231.03588,238.02891,237.05,244.06,243.06,247.07,247.07,251.08,252.08,257.10,258.10,259.10,262.11,261.11,262.11,266.12,264.12,269.13,268.14,271.15,272.15,277,0,285,0,289,0,293"
  split(ms,atmass,",")
  for (j in atsym) atnmr[atsym[j]]=j
  #print atsym[8]
  #print atnmr["Ti"]
  #print atmass[8]

  pi=3.14159265358979; #  
  kb=1.3806503e-23;    # kg m^2 / K s^2
  T=300;               # K
  kbT=kb*T
  atmu= 1.6605387e-27  # kg
  hbar= 1.0545716e-34  # kg m^2 / s
  cm2hz= 2.9979246e+10/2.0/pi
}
#==============================================================================
# Read all the necessary data
#==============================================================================a

/TITEL  =/{atm_type[++iatom_type]=$4;}

/ions per type =/{
  for(i=5;i<=NF;i++){ntype[i-4]=$i;nvat=nvat+$i}
  ntypes=NF-4
}

/Mass of Ions in am/{
  getline;
  for(i=1;i<=NF-2;i++){
    typeMass[i]=$(i+2);
    for(j=1;j<=ntype[i];j++){
      iatm++;
      atm_mass[iatm]=typeMass[i];
      atm_label[iatm]=atm_type[i];
      #print iatm,atm_type[i],atm_mass[iatm]
    }
  }
}

/Eigenvectors and eigenvalues of the dynamical matrix/ {read=1}
/Eigenvectors after division by SQRT\(mass\)/{EndReached=1}

/f  =.*THz.*2PiTHz.*cm-1.*meV/ && (!EndReached) {
  nfreq++;freq[nfreq]=$8;
  getline;
  getline;iatm=0
  while(NF==6){
    iatm++
    rx[iatm]=$1; ex[iatm,nfreq]=$4;
    ry[iatm]=$2; ey[iatm,nfreq]=$5;
    rz[iatm]=$3; ez[iatm,nfreq]=$6;
    getline;
  }
}


#==============================================================================
#==============================================================================
END{
  if (T < 1) {T= 300; print "# Temperature of configuration forced to = "T" K" } # Avoids T=0

  kbT=kb*T

  print "# i  atmN     Z        MSDx         MSDy        MSDz        MSD [angstrom]"
  for (i=1;i<=nvat;i++) {
    mass_i   =  atm_mass[i]; 
    sqmass_i =  sqrt(mass_i)
    for(f=1;f<=nfreq;f++) {

      if(freq[f] > 30.0){
        term= coth(0.5*hbar*freq[f]*cm2hz/kbT)/(freq[f]*cm2hz)
        
        #wght= fw[f]
        wght=1.0/nfreq; 

        sumx[i]=sumx[i]+wght*term*(ex[i,f]*ex[i,f])
        sumy[i]=sumy[i]+wght*term*(ey[i,f]*ey[i,f])
        sumz[i]=sumz[i]+wght*term*(ez[i,f]*ez[i,f])

        sumq[i]=sumq[i]+wght*term*(ex[i,f]*ex[i,f] + ey[i,f]*ey[i,f] + ez[i,f]*ez[i,f])
      }
    }

    msd_x[i]  = hbar/(2.*mass_i*atmu)*sumx[i]*1.e20;
    msd_y[i]  = hbar/(2.*mass_i*atmu)*sumy[i]*1.e20;
    msd_z[i]  = hbar/(2.*mass_i*atmu)*sumz[i]*1.e20;
    msd_tot[i]= hbar/(2.*mass_i*atmu)/3.0*sumq[i]*1.e20;
    printf"%4i %-3s %9.5f %11.7f %11.7f %11.7f %11.7f\n", i,atm_label[i],rz[i],msd_x[i],msd_y[i],msd_z[i],msd_tot[i]
  }
}

function coth ( x ) { 
  exp2x=exp(2.0*x);
  return (exp2x + 1.0)/(exp2x -1.0) 
}

