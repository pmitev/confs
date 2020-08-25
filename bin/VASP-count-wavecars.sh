#!/bin/sh

#find $1 -name WAVECAR -size +10M -exec sh -c "ls -l {} | awk '{print \$5} ' " \; | awk '{sum=sum+$1;i++} END {printf "Found %d WAVECARs Occupying %.2f GB\n",i,sum/1024**3}'

RESULT=$(find $1 -name WAVECAR -size +10M -exec sh -c "ls -l {} | awk '{print \$5} ' " \; | awk '{sum=sum+$1;i++} END {printf "%d  %.2f\n",i,sum/1024**3}')
RESULT=($RESULT) # split the variable in array 
NF=${RESULT[0]}
SIZE=${RESULT[1]}

echo "====================================================================================" >  /tmp/wavecars.txt
echo "Found $NF  WAVECAR files occupying $SIZE GB"                                    | tee -a /tmp/wavecars.txt
echo "====================================================================================" >> /tmp/wavecars.txt
find $1 -name WAVECAR -size +10M -exec ls -lh {} \;                                         >> /tmp/wavecars.txt
echo "====================================================================================" >> /tmp/wavecars.txt

#if (( $(echo "$SIZE 5" | awk '{print ($1 > $2)}') )); then
#   fuser=$(ls -ld /home/pmitev | awk '{print $3}')
#   cat /tmp/vawecars.txt
#fi
