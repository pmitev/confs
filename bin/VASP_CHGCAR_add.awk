#!/usr/bin/awk -f
BEGIN{
  NF=1;  while(NF>0){ getline < ARGV[2];        } getline < ARGV[2]; 
  NF=1;  while(NF>0){ getline < ARGV[1]; print  } getline < ARGV[1]; print; 
 
  getline < ARGV[1];split($0,d1)
  getline < ARGV[2];split($0,d2)
  while($1*1==$1){
    for(i=1;i<=NF;i++) printf "%18.11e ", d1[i]+d2[i]
    print""
    $1="test"
    getline < ARGV[1];split($0,d1)
    getline < ARGV[2];split($0,d2)
  }
  
}


