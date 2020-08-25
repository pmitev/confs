#!/usr/bin/python3
import numpy as np
import os,sys
from math import degrees, radians
from ase.io import read


eV2au=0.0194469057312645;
ang2bohr= 1./0.52917721;
mH= 1.007825; mO= 15.994910; mD = 2.014102;

fin=   str(sys.argv[1])
structure= read(fin)
np.set_printoptions(linewidth=180)

print (structure.get_all_distances())
