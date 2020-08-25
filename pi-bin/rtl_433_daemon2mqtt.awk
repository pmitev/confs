#!/usr/bin/awk -f
BEGIN{
  FS=","
  cmd="rtl_433 -F csv -q -p 24 -R 19 -R 33 -R 49 -R 50 2> /dev/null" 
  cmd="rtl_433 -F csv -q -p 24 2> /dev/null" 

  # Get csv column labels and count
  cmd | getline; csvNF= NF;  header=$0;
  
  while( cmd | getline){
    if (NF==csvNF){

      if ($2=="Proove") sensor="$3""$22"
      else if ($2=="Kangtai") sensor= 0; # sensor=$89;
      else sensor=$3$4
      
      fn= "/dev/shm/rtl_"sensor
      print $0 > fn; close(fn);

      cmd_m= "mosquitto_pub -h m20.cloudmqtt.com -u user -P mmnmmn -p 14452 -t 'test/"sensor"'  -l -r --capath /etc/ssl/certs "
      cmd_m= "mosquitto_pub -t 'test/"sensor"'  -l -r"
      print $0 | cmd_m
      close(cmd_m)

    } 
  }

}
