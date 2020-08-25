#!/usr/bin/awk -f
#############################################################################
#                                                                           #
# GNU License - Author: Pavlin D. Mitev                        2004-08-14   #
# Version 0.1                                                               #
#                                                                           #
#############################################################################a
BEGIN{
  getline;
  printf"plot \""ARGV[1]"\"  w l lt 1" 
  for (i=2; i<=NF;i++) { 
    printf ",\"\" u 1:"i" w l lt "i 
  }
  print"" 
}

