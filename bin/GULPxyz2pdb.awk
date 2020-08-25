#!/usr/bin/awk -f 
BEGIN {print "REMARK Converted from GULP .xyz";beg=0; }

{
  if (NF == 1) {
    if (beg!=0) print "END";
    print "REMARK Number of Atoms = "$1;beg=1;
  }
  if (NF == 4) {printf "\
HETATM%6i%4s%9s1    %8.3f%8.3f%8.3f\n",i,$1,s,$2,$3,$4;i++}
}

END {print "END"}

