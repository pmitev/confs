#!/usr/bin/awk -f


/DIRECT LATTICE VECTORS CARTESIAN COMPONENTS/{
  getline;
  getline; h[1]=$1; h[2]=$2; h[3]=$3
  getline; h[4]=$1; h[5]=$2; h[6]=$3
  getline; h[7]=$1; h[8]=$2; h[9]=$3
}

/CARTESIAN COORDINATES/{
  getline;getline;getline;getline;
  while(NF>1){
    xx[$1]=$4; yy[$1]=$5; zz[$1]=$6+0; atmlabel[$1]=$3; 
    getline
  }
}





/NORMAL MODES NORMALIZED TO CLASSICAL AMPLITUDES/{vibsec=1}

/FREQ\(CM\*\*-1\)/ {
  nmods=NF-1; for (i=1;i<=nmods;i++) fmod[i]=$(i+1)+0
  
  getline;getline;
  
  while(NF>1){
    if ($1=="AT.") {
      line="";
      atmnum=$2; atmlabel[$2]=$3; 
      for(i=4;i<=NF;i++) line=line" "$i;
      $0=line;
    }
    
    for (i=1;i<=nmods;i++){
      eig[atmnum,$1,i]=$(i+1)+0.
    }
    getline
  }
 
  for(i=1;i<=nmods;i++){
    framep="";lines=0;
    for(j=1;j<=atmnum;j++) {
      x=xx[j];y=yy[j];z=zz[j]
      framep=framep sprintf("%-2s %7f %7f %7f 0 %7f %7f %7f\n",atmlabel[j],x,y,z,eig[j,"X",i], eig[j,"Y",i], eig[j,"Z",i]);lines++
#      if(x==0){ x=h[1]+h[4]+h[7];
#        framep=framep sprintf("%-2s %7f %7f %7f 0 %7f %7f %7f\n",atmlabel[j],x,y,z,eig[j,"X",i], eig[j,"Y",i], eig[j,"Z",i]); lines++
#      }
#      if(y==0){ y=h[2]+h[5]+h[8];
#        framep=framep sprintf("%-2s %7f %7f %7f 0 %7f %7f %7f\n",atmlabel[j],x,y,z,eig[j,"X",i], eig[j,"Y",i], eig[j,"Z",i]); lines++
#      }
#      if(z==0){ z=h[3]+h[6]+h[9];
#        framep=framep sprintf("%-2s %7f %7f %7f 0 %7f %7f %7f\n",atmlabel[j],x,y,z,eig[j,"X",i], eig[j,"Y",i], eig[j,"Z",i]); lines++
#      }
    }
    
    print lines; 
    print "FREQ N "++nmod,fmod[i],"cm-1 A IRint 0 RAMAN_int 10"
    printf framep 
  } 
}
