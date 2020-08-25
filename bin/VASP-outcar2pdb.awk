#!/bin/awk -f
BEGIN{
  for(i=2;i<=ARGC;i++){typeT[i-1]=ARGV[i];}
  ARGC=2;

# cmd="grep POSITION "ARGV[1]" | wc"; cmd |& getline; steps=$1; close(cmd); print steps
# cmd="head -300| grep 'number of ions     NIONS' "ARGV[1]; cmd |& getline; nions=$12; close(cmd); 
  print "REMARK Converted from OUTCAR";
# print "0        1         2         3         4         5         6         7"
# print "1234567890123456789012345678901234567890123456789012345678901234567890";
}


/ions per type =/{
  for(i=5;i<=NF;i++){ntype[i-4]=$i;natoms=natoms+$1}
  ntypes=NF-4
}

/length of vectors/ {getline; a=$1; b=$2; c=$3;}

/POSITION                                       TOTAL-FORCE/{
#  print "         1         2         3         4         5         6         7 "
#  print "1234567890123456789012345678901234567890123456789012345678901234567890 "
#  print "CRYST1  117.000   15.000   39.000  90.00  90.00  90.00 P 21 21 21    8 "
  
  printf "CRYST1%9.3f%9.3f%9.3f%7.2f%7.2f%7.2f %-11s%4s\n",a,b,c,90,90,90,"P 1","1"
  step++; k=0; getline;
# print nions 
  for(t=1;t<=ntypes;t++){
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

      
      printf "HETATM%5i%4s%9s1    %8.3f%8.3f%8.3f%6.2f\n",k,typeT[t],ls,x,y,z,1;
#     printf "HETATM%6i%4s%9s1    %8.3f%8.3f%8.3f\n",k,$1,s,$1,$2,$3;

      xold[k]=x; yold[k]=y; zold[k]=z;
    }
  }
  print "END"  
}
