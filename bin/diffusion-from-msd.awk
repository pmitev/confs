#!/usr/bin/awk -f
# time step ts in pm [1e-12s]
BEGIN {ts=0.005;gnu="gnuplot -persist"}
{
if ( FNR == 1 ) print $1*ts, $2/3. > "diff.tmp"
if ( FNR >=2 ) {
  print $1*ts, $2/3. >> "diff.tmp"
}
}
END{
print "f(x)=6.*b*x" | gnu
print "fit f(x) \"diff.tmp\" via b" | gnu
print "print \"Diffusion coefficient= \",b*1e-4,\" [cm^2/s]\" " | gnu
print "set yrange[0:]" | gnu
print "set xlabel \"Time (ps)\"" | gnu
print "set ylabel \"MSD (A^2)\"" | gnu
print "plot \"diff.tmp\" w l, f(x) "| gnu
}
