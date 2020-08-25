#!/usr/bin/awk -f
BEGIN{
  cmd="rtl_433 -F csv -q -p 24 2> /dev/null"
  cmd | getline csvline; close(cmd)

  #getline csvline < "/home/pi/bin/rtl-csv.dat"
  split(csvline,csv,",")
}

{
  print "======================="
  N= split($0,field,",")
  for (i=1; i<=N; i++) if (field[i]) printf("%3i : %s\t%s\n",i,csv[i],field[i])
}
