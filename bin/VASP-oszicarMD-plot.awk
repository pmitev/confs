#!/bin/awk -f
BEGIN{
  ppid=PROCINFO["ppid"]; ofile= "/tmp/vasp-plot"ppid".tmp"; print ofile
  print "# step ETOTAL EKIN TEMP TOTEN" > ofile
}

/T=/    { 
  TEMP=$3; EKIN=$11; ETOTAL= $5; TOTEN=$9
  i++
  printf "%i  %f %f %f %f\n",i,ETOTAL,EKIN,TEMP,TOTEN  >> ofile
} 

END{
  close(ofile)
  gnu= "(gnuplot)"
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

  print "set origin .5,.0" |& gnu
  print "set nokey; set ylabel'EKIN/TEMP'; set xlabel 'step'" |& gnu
  print "plot '"ofile"' u 1:($3/$4)  w l" |& gnu

  print "" |& gnu
  print "set nomultiplot" |& gnu
  close(gnu)
  cmd= "mv /tmp/vasp-plot"ppid".ps MD-plot.ps";system(cmd); close(cmd)
  cmd= "gv MD-plot.ps";                        system(cmd); close(cmd)
  cmd= "rm "ofile" ";   system(cmd); close(cmd)
}
