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

  pi   = 3.14159265358979;       #  
  kb   = 1.3806503e-23;          # kg m^2 / K s^2
  atmu = 1.6605387e-27           # kg
  hbar = 1.0545716e-34/2/pi      # kg m^2 / s
  cm2hz= 2.9979246e+10 *2.0*pi   #
}

#==============================================================================
# Read all the necessary data
#==============================================================================
/Version =/                      {gsub("  ","");gsub("*",""); print "# GULP "$0}         # Prints the GULP version
/Temperature of configuration =/ {T= $5; print "# Temperature of configuration = "T" K"} # Sets the temperature

/No\.  Atomic       x           y          z         Charge      Occupancy/ && grsl==0{ r_coord=1}  # Detects the coordinate section

$1~/^[[:digit:]]+$/ && $3=="c" && grsl==0 {
  gsub("*","",$0)
  atm_chrg[$1]= $7
  atm_sign[$1]= $2;
  rx[$1]=$4;ry[$1]=$5;rz[$1]=$6
}

/General input information/{grsl=1}                           # Detects the end of the input information
#------------------------------------------------------------------------------
/Frequencies \(cm-1\) and Eigenvectors :/ {inp=1}                     # Detects the begining of the eigenvectors block
/Real    Imaginary   Real    Imaginary   Real    Imaginary/ {imgnr=1} # Detects the imaginary case 
/  K point / {nkpt=$3; wght=$10}                                      # Counts the numbers of K points and takes the weights


$1~/Frequency/ && $2~/^[[:digit:]]/{
  for (i=2;i<=NF;i++){ nfreq++; freq[nfreq]=$i; }
}

$1~/^[[:digit:]]+$/ && $2~/[xyz]/ && inp==1 {
  if(imgnr==1){
    for (i=3;i<=NF;i+=2){
      fw[nfreq-3+int(i/2)]= wght;
      if($2=="x") { ex[$1,nfreq-3+int(i/2)]=$i; exi[$1,nfreq-3+int(i/2)]=$(i+1) }
      if($2=="y") { ey[$1,nfreq-3+int(i/2)]=$i; eyi[$1,nfreq-3+int(i/2)]=$(i+1) }
      if($2=="z") { ez[$1,nfreq-3+int(i/2)]=$i; ezi[$1,nfreq-3+int(i/2)]=$(i+1) }
      if ($1 > nvat) nvat=$1
    }
  }
  else {
    for (i=3;i<=NF;i++){
      fw[nfreq-6+i-2]= wght;
      if($2=="x") ex[$1,nfreq-6+i-2]=$i 
      if($2=="y") ey[$1,nfreq-6+i-2]=$i 
      if($2=="z") ez[$1,nfreq-6+i-2]=$i 
      if ($1 > nvat) nvat=$1
    }
  }  
}
#==============================================================================
#==============================================================================
END{
  if (T < 1) {T= 300; print "# Temperature of configuration forced to = "T" K" } # Avoids T=0
  
  kbT=kb*T
  
  print "# i  atmN     Z        MSDx         MSDy        MSDz        MSD [angstrom]"
  for (i=1;i<=nvat;i++) {
    mass_i   =  atmass[atnmr[atm_sign[i]]]
    sqmass_i =  sqrt(mass_i)
    chrg     =  atm_chrg[i]
    for(f=1;f<=nfreq;f++) {
      intx[i,f]= ex[i,f] * chrg/sqmass_i
      inty[i,f]= ey[i,f] * chrg/sqmass_i
      intz[i,f]= ez[i,f] * chrg/sqmass_i
      
      sum[f]=sum[f] + intx[i,f] + inty[i,f] + intz[i,f]

      if(freq[f] != 0.0){
        term1= 1./((freq[f]*cm2hz)**2)
        term2= ((hbar/(kbT))**2)/12.0
        term3= -(freq[f]*cm2hz)**2*((hbar/(kbT))**4)/720.0
      }
#      print term1,term2,term3
      wght= fw[f]
      
      sumx[i]=sumx[i]+wght*(term1+term2+term3)*(ex[i,f]*ex[i,f]+(exi[i,f]*exi[i,f])  )
      sumy[i]=sumy[i]+wght*(term1+term2+term3)*(ey[i,f]*ey[i,f]+(eyi[i,f]*eyi[i,f])  )
      sumz[i]=sumz[i]+wght*(term1+term2+term3)*(ez[i,f]*ez[i,f]+(ezi[i,f]*ezi[i,f])  )
      
      #sumx[i]=sumx[i]+wght*(term1+term2+term3)*(abs(ex[i,f]*ex[i,f]+(exi[i,f]*exi[i,f]))  )
      #sumy[i]=sumy[i]+wght*(term1+term2+term3)*(abs(ey[i,f]*ey[i,f]+(eyi[i,f]*eyi[i,f]))  )
      #sumz[i]=sumz[i]+wght*(term1+term2+term3)*(abs(ez[i,f]*ez[i,f]+(ezi[i,f]*ezi[i,f]))  )
      
      sumq[i]=sumq[i]+wght*(term1+term2+term3)*(ex[i,f]*ex[i,f]+exi[i,f]*exi[i,f]  +  ey[i,f]*ey[i,f]+eyi[i,f]*eyi[i,f]  +  ez[i,f]*ez[i,f]+ezi[i,f]*ezi[i,f])
    }
    
    msd_x[i]  = kbT/(mass_i*atmu)*sumx[i]*1.e20; 
    msd_y[i]  = kbT/(mass_i*atmu)*sumy[i]*1.e20; 
    msd_z[i]  = kbT/(mass_i*atmu)*sumz[i]*1.e20; 
    msd_tot[i]= kbT/(mass_i*atmu)/3.0*sumq[i]*1.e20; 
    printf"%4i %-3s %9.5f %11.7f %11.7f %11.7f %11.7f\n", i,atnmr[atm_sign[i]],rz[i],msd_x[i],msd_y[i],msd_z[i],msd_tot[i] 
  }
}


function abs ( x ) { return (x >= 0) ? x : -x }
