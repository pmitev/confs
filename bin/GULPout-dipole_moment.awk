#!/usr/bin/awk -f
# x,y,z in Angstroms
BEGIN {
print "------------------------------------------------------------------------";
print " Charge       x          y         z          Atomic No.                ";
print "------------------------------------------------------------------------";
  cmd="GULPout2ymol.awk "ARGV[1]" | sed -n -e '3,$ p'" 
    while (( cmd |& getline) > 0) {
      printf"%7.4f\t %9.5f  %9.5f  %9.5f\t%3d\n",$1,$2,$3,$4,$5
      mx= mx - $2*$1; my= my - $3*$1; mz= mz - $4*$1;
    }


norm=sqrt(mx**2+my**2+mz**2);
# Convert to Debye
  mx= mx*3.335641; my= my*3.335641; mz= mz*3.335641;
  norm= norm*3.335641;
print "";
print "------------------------------------------------------------------------";
printf("Dipole Moment\t  x\t\t  y\t\t  z\t\t| D.Moment |\n");
print "------------------------------------------------------------------------";
printf(" [ Debye ]   \t%e\t%e\t%e\t%e\n", mx, my, mz, norm);

}
