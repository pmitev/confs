#!/usr/bin/awk -f
BEGIN{
  au2a=0.52917721
  print "conv"
}

/cell vectors/ {print "vectors";
   getline; printf"  %.5f %.5f %.5f\n",$1*au2a,$2*au2a,$3*au2a; 
   getline; printf"  %.5f %.5f %.5f\n",$1*au2a,$2*au2a,$3*au2a; 
   getline; printf"  %.5f %.5f %.5f\n",$1*au2a,$2*au2a,$3*au2a; 
}

/coordinates/{
  print "cartesian"
  while (getline){
    if($0 !~ "END") printf"%-4s  %9.6f %9.6f %9.6f\n",$1,$2*au2a,$3*au2a,$4*au2a;
  }
}
