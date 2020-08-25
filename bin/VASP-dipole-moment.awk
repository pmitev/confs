#!/usr/bin/awk -f 

/dipolmoment/{
  print; 
  print "Dipole moment: "sqrt($2**2 + $3**2 + $4**2)*4.80320425 " [D]"
}
