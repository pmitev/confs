#!/usr/bin/awk -f
BEGIN{
  FS=","
  cmd="rtl_433 -F csv -q -p 24 -R 19 -R 33 -R 49 -R 50 2> /dev/null" 
  cmd="rtl_433 -F csv -q -p 24 2> /dev/null" 
#  cmd="/home/pi/opt2/rtl_433/build/src/rtl_433 -F csv -q -p 24 2> /dev/null" 

  # Color definitions 
  Cgreen=  "\033[1;32m"
  Cyellow= "\033[1;33m"
  Cred=    "\033[1;31m"
  CBred=   "\033[0;41m"
  Clblue=  "\033[1;36m"
  Cblue=   "\033[1;34m"
  Cnorm=   "\033[0m"

  # Get csv column labels and count
  cmd | getline; csvNF= NF;  header=$0;
  
  while( cmd | getline){
    if (NF==csvNF){

      if ($2=="Proove" || $2=="Nexa") sensor=$3+$22
      else if ($2=="Kangtai") sensor= 0; # sensor=$89;
      else sensor=$3$4
      
      fn= "/dev/shm/rtl_"sensor
      print $0 > fn; close(fn);

      if (($5!="OK") && ($5!="")) {
        fn= "/dev/shm/rtl-BAT"
        print $0 >> fn; close(fn);
      }
    } 
  }

}
