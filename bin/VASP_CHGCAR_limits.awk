#!/usr/bin/awk -f
# Filters charge density in to a minlin and maxlim
BEGIN{
  NF=1;  while(NF>0){ getline < ARGV[1]; print  } getline < ARGV[1]; print; 

  minlim=ARGV[2]
  maxlim=ARGV[3]

 
  getline < ARGV[1]

  while($1*1==$1){
    for(i=1;i<=NF;i++) {
      tmp=$i
      if ($i < minlim ) tmp= minlim
      if ($i > maxlim )  tmp= maxlim
      printf  "%18.11e ",tmp
    }
    print""
    $1="test"
    getline < ARGV[1];
  }
  
}


