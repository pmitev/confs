#!/usr/bin/python
import numpy as np
import os,sys
from math import degrees, radians
from ase.data import covalent_radii
from ase.io import read


eV2au=0.0194469057312645;
ang2bohr= 1./0.52917721;
mH= 1.007825; mO= 15.994910; mD = 2.014102;


fin=       str(sys.argv[1])
atom1= int(sys.argv[2]) - 1
atom2= int(sys.argv[3]) - 1
atom3= int(sys.argv[4]) - 1

structure= read(fin)
structure.translate(-structure.get_positions()[atom2])

vX= np.array([1.,0.,0.])

vOH1= structure.get_positions()[atom1] - structure.get_positions()[atom2]
vOH2= structure.get_positions()[atom3] - structure.get_positions()[atom2]
vMid= (vOH1/np.linalg.norm(vOH1) + vOH2/np.linalg.norm(vOH2)); vMid= vMid/np.linalg.norm(vMid)


# =============================================================================
#Get the axis and angle
angle= np.arccos(np.dot(vX,vMid))
axis= np.cross(vX,vMid)/np.linalg.norm(np.cross(vX,vMid))

#A skew symmetric representation of the normalized axis
axis_skewed= np.array([ [    0.   , -axis[2] ,  axis[1]],
                        [ axis[2] ,     0.   , -axis[0]],
			[-axis[1] , axis[0]  ,    0.   ]  ])

# Rodrigues formula for the rotation matrix
R= np.eye(3) + np.sin(angle)*axis_skewed + (1.-np.cos(angle))*np.dot(axis_skewed,axis_skewed)
# =============================================================================
structure.positions= np.dot(structure.positions,R) 


vX= np.array([0.,0.,1.])

# =============================================================================
# Get the axis and angle
uproj= np.array([0. , structure.positions[atom1,1], structure.positions[atom1,2] ]); uproj= uproj/np.linalg.norm(uproj)
angle= np.arccos(np.dot(vX,uproj))
axis= np.cross(vX,uproj)/np.linalg.norm(np.cross(vX,uproj))

# A skew symmetric representation of the normalized axis
axis_skewed= np.array([ [    0.   , -axis[2] ,  axis[1]],
                        [ axis[2] ,     0.   , -axis[0]],
			[-axis[1] , axis[0]  ,    0.   ]  ])

# Rodrigues formula for the rotation matrix
R= np.eye(3) + np.sin(angle)*axis_skewed + (1.-np.cos(angle))*np.dot(axis_skewed,axis_skewed)
# =============================================================================
structure.positions= np.dot(structure.positions,R) 

natoms= len(structure)
print natoms
print " xyz"
for i in xrange(natoms):
  print "{0:5s}{1:.12f} {2:.12f} {3:.12f}".format(structure.get_chemical_symbols()[i], structure[i].x, structure[i].y, structure[i].z )

