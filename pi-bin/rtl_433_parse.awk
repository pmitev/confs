#!/usr/bin/awk -f
BEGIN{
  FS=","
  cmd="rtl_433 -F csv -q -p 24 -R 19 -R 33 -R 49 -R 50 2> /dev/null" 
  cmd="rtl_433 -F csv -q -p 24 2> /dev/null" 

  PROCINFO["sorted_in"]= "@ind_num_asc"

  # Color definitions 
  Cgreen=  "\033[1;32m"
  Cyellow= "\033[1;33m"
  Cred=    "\033[1;31m"
  CBred=   "\033[0;41m"
  Clblue=  "\033[1;36m"
  Cblue=   "\033[1;34m"
  Cbold=   "\033[1m"
  Cnorm=   "\033[0m"

  now= systime()
}

{
  if ($2=="Proove" || $2=="Nexa") sensor=$4+$22
  else if ($2~"LaCrosse") sensor= $4
  else if ($89) sensor= $89
  else sensor=$4$5

  id  [sensor]= sensor
  time[sensor]= $1
  name[sensor]= $2
  bat [sensor]= $6
  temp[sensor]= $7
  humidity[sensor]= $10
  state[sensor]= $11
  command[sensor]= $16
  unit[sensor]= $14



  # Assign user friendly labels for known sensors
  if (sensor==  61) name[sensor]= "Gym - WT450"
  if (sensor==1602) name[sensor]= "Outdoors - Nexus"
  if (sensor== 131) name[sensor]= "Indoors  - WT450"
  if (sensor== 151) name[sensor]= "Outdoors - WT450"
  if (sensor== 183) name[sensor]= "V.room - Telldus"
  if (sensor== 184) name[sensor]= "Ventilation - Telldus"
#  if (sensor== 351) name[sensor]= "Ventilation - Nexus"
  if (sensor== 361) name[sensor]= "Garage - TE44"

  if (sensor==52597761) name[sensor]= "Proove: Living room #1"
  if (sensor==52597762) name[sensor]= "Proove: Living room #2"
  if (sensor==52597763) name[sensor]= "Proove: Living room #3"
  if (sensor==55703571) name[sensor]= "Proove: Garage"
  if (sensor==11405294) name[sensor]= "Klick: Garage"
  if (sensor==52337311) name[sensor]= "Proove: Laundry"
  if (sensor==53659770) name[sensor]= "Proove: Veranda"
  if (sensor==35709959) name[sensor]= "Proove: Desk-viv"
  if (sensor==52673474) name[sensor]= "Proove: Kartina"
  if (sensor==52673475) name[sensor]= "Proove: Stereo"
  if (sensor==52673476) name[sensor]= "Proove: Kartina #1"
  if (sensor==43876366) name[sensor]= "Proove: Kitchen"
  if (sensor==42449922) name[sensor]= "Proove: mini.Charger"
  if (sensor==42449921) name[sensor]= "Proove: Chromecast"
  if (sensor==42449920) name[sensor]= "Proove: mini.3"
  if (sensor==7296007 ) name[sensor]= "Proove: Router"
  if (sensor==59749763) name[sensor]= "Nexa: Door-veranda"
  if (sensor==35709958) name[sensor]= "Proove: Coridor-2nd floor"
  if (sensor==50637154) name[sensor]= "Proove: Alarm"
  #if (sensor==11405294) name[sensor]= "Door - Veranda" 

  # Add some colors to the output
  if (bat[sensor]=="OK")   {bat[sensor]=Cgreen bat[sensor]" "Cnorm}     else {bat[sensor]=Cred bat[sensor] Cnorm}
  if (state[sensor]=="ON") {state[sensor]=Cgreen state[sensor] Cnorm} else {state[sensor]=Cred state[sensor] Cnorm}
  if (command[sensor]=="On") {command[sensor]=Cgreen command[sensor] Cnorm} else {command[sensor]=Cred command[sensor] Cnorm}
  
  stringdate= time[sensor];
  gsub("-|:"," ",stringdate);
  linedate= mktime(stringdate);
  howold[sensor]= now-linedate

}

END{printdata()}


# Print collected data in table form
function printdata(){
  print "==================================================================================="
  print "|        Time         |               Name             |  ID  |  Temp |   %  | Bat"
  print "==================================================================================="
  for (i in id){
    if (howold[i] < 120) time[i]= Cbold time[i] Cnorm
    if (name[i]~"^Proove|^Nexa") printf("| %19s | %-30s | %9s | %3s \n",time[i],name[i],id[i],state[i]"          ")
    else if (name[i]~"^Klick") printf("| %19s | %-30s | %9s | %3s \n",time[i],name[i],id[i],command[i]"          ")
    else if (name[i]~"^Kangtai") printf("| %19s | %-30s | %9s | %3s \n",time[i],name[i],id[i],command[i]"          ")
    else printf("| %19s | %-30s | %4s | %5.1f | %3i% | %s\n",time[i],name[i],id[i], temp[i], humidity[i], bat[i])
  }
  print "==================================================================================="
}
