###!/usr/bin/python
import numpy as np
import os, sys
from ase import Atoms
from ase.io.trajectory import Trajectory
from ase.visualize import view
from ase.calculators.neighborlist import *
# Version 2014.01.29


f= open("traj.xyz")
traj = Trajectory('CO2-111.H2O.traj', 'w')
frame=0

while True:
  line= f.readline()
  if not line:
    break
  d= line.split();  natoms= int(d[0]); frame+= 1;
  sym=[]; pos=[];
  line= f.readline(); line= line.replace(",",""); d= line.split(); sys.stdout.write(".");sys.stdout.flush()
  step= int(d[2]); timestep= float(d[5])
  for i in range(natoms):
    line= f.readline();d= line.split();
    sym.append(d[0]); pos.append([float(d[1]), float(d[2]), float(d[3])] )
  
  structure= Atoms(symbols=sym,
      cell= [14.91763, 14.91763, 14.91763], pbc= 1,
      positions= pos)
  traj.write(structure)
  if int(frame/100) == frame/100. :
    print frame
