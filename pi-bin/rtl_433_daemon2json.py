#!/usr/bin/python3
import subprocess
import shlex
import json

#command="/home/pi/Rubicson/rtl_433_Rubicson -p 24 -R 133 -F json"  #Rubicson
command="/home/pi/opt2/rtl_433/build/src/rtl_433 -p 24 -G -M newmodel -F json" 

process= subprocess.Popen(shlex.split(command), stdout=subprocess.PIPE)
while True:
  output = process.stdout.readline()
  if output == '' and process.poll() is not None:
    break
  if output:
    #print(">> " + str(output.strip()))
    jout= json.loads(output.decode('utf8'))
    #print(jout.keys())

    ID= jout.get("model") + str(jout.get("id","")) + str(jout.get("channel",""))

    fn= open("/dev/shm/rtl_"+ID+".json","w")
    fn.write(output.decode('utf8'))
    fn.close()

rc = process.poll()
