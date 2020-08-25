#!/bin/bash

NFILES=0
clear

#watch -c -t rtl_433_parse.awk /dev/shm/rtl_*

#while [ 1 -gt 0 ]
#do
#  echo -ne "\033[0;0H"
#  rtl_433_parse.awk /dev/shm/rtl_*
#  sleep 2
#done

while true 
do 
  echo -ne "\033[0;0H"
  ntmp=$(ls -1 /dev/shm/rtl_* | wc -l)
  if [ $ntmp != $NFILES ]; then clear ; NFILES=$ntmp; fi 
  rtl_433_parse.awk /dev/shm/rtl_*
  inotifywait -qq -e close_write /dev/shm 
done
