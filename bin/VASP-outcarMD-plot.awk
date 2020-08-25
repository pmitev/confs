#!/bin/awk -f
BEGIN{
  ppid=PROCINFO["ppid"]; ofile= "/tmp/vasp-plot"ppid".tmp"; print ofile
  print "# step ETOTAL EKIN TEMP TOTEN" > ofile
}

/SYSTEM =/ {sys=$3$4}
/kinetic Energy EKIN/      { EKIN= $5; TEMP= $7}
/ion-electron   TOTEN/     { TOTEN= $5 }
/total energy   ETOTAL/    { ETOTAL= $5
  i++
  printf "%i  %f %f %f %f\n",i,ETOTAL,EKIN,TEMP,TOTEN  >> ofile
} 

END{
  close(ofile)
  gnu= "(gnuplot -persist )"
  print "set term postscript enhanced color;  set output '/tmp/vasp-plot"ppid".ps'" |& gnu
  print "set multiplot;  set size .5,.5" |& gnu
  print "set origin 0,.5" |& gnu
  print "set nokey; set ylabel'ETOTAL'; set xlabel 'step'" |& gnu
  print "plot '"ofile"' u 1:2  w l" |& gnu
  
  print "set origin 0.5,.5" |& gnu
  print "set nokey; set ylabel'TEMP'; set xlabel 'step'" |& gnu
  print "plot '"ofile"' u 1:4  w l" |& gnu

  print "set origin 0.,.0" |& gnu
  print "set nokey; set ylabel'TOTEN'; set xlabel 'step'" |& gnu
  print "plot '"ofile"' u 1:5  w l" |& gnu

  print "" |& gnu
  print "set nomultiplot" |& gnu
  close(gnu)
  cmd= "gv /tmp/vasp-plot"ppid".ps"; system(cmd); close(cmd)
  cmd= "rm "ofile" /tmp/vasp-plot"ppid".ps";   system(cmd); close(cmd)
}
