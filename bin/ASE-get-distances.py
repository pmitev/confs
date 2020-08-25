#!/usr/bin/python3
import numpy as np
import os,sys
from math import degrees, radians
from ase.io import read


eV2au=0.0194469057312645;
ang2bohr= 1./0.52917721;
mH= 1.007825; mO= 15.994910; mD = 2.014102;

nn= len(sys.argv)

fin=   str(sys.argv[1])

structure= read(fin)

for i in range(3,nn):
  print ("d:{0}-{1}\t{2}".format(str(sys.argv[2]),int(sys.argv[i]),structure.get_distance(int(sys.argv[2])-1,int(sys.argv[i])-1,mic=True)) )
