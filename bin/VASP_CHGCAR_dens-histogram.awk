#!/usr/bin/awk -f
# Makes a histogram of the charge density distribution 
BEGIN{
  NF=1;  while(NF>0){ getline < ARGV[1]; } getline < ARGV[1];  

  getline < ARGV[1]; 

  while($1*1==$1){
    for(i=1;i<=NF;i++) {
      print $i | "histogram.exe"
    }
    $1="test"
    getline< ARGV[1];
  }
}


