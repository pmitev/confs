#/bin/bash

time1=$(date -d "$1" +%s)
time2=$(date -d "$2" +%s)

T=$(($time2-$time1))
H=$(($T / 3600)); M=$(( ($T - $H * 3600) / 60 )); S=$(( ($T - $H * 3600 - $M * 60) ))
printf "=:= Elapsed time: %dh:%02dm:%02ds\n" $H $M $S
