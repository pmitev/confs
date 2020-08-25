#!/usr/bin/awk -f
NF == 0 { 
  getline; nx=$1; ny=$2; nz=$3

  while (getline && ($1+0 == $1) ) {
    for (i=1; i<=NF;i++) sum+= $i
  }
}
END {printf "%.6f\n",sum/nx/ny/nz}
