#!/usr/bin/python3
import numpy as np
import os,sys
#from math import degrees, radians
from ase.io import read


eV2au=0.0194469057312645;
ang2bohr= 1./0.52917721;
mH= 1.007825; mO= 15.994910; mD = 2.014102;

nn= len(sys.argv)

fin=   str(sys.argv[1])

structure= read(fin)

print ( "a:{0}-{1}-{2}\t{3}".format(str(sys.argv[2]),str(sys.argv[3]),str(sys.argv[4]), (structure.get_angle(int(sys.argv[2])-1,int(sys.argv[3])-1,int(sys.argv[4])-1))) )
