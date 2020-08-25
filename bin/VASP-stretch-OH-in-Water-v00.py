#!/usr/bin/python
import numpy as np
import os,sys
from ase import Atoms
from ase.visualize import view
from ase.calculators.neighborlist import *
from compiler.ast import flatten
import ase.io.vasp
from ase.io.vasp import read_vasp_out, read_vasp, write_vasp
import copy

# Version 2015.02.02

e0=0.00552635;  # Vacuum permittivity constant C/V
eV2au=0.0194469057312645;
ang2bohr= 1./0.52917721;

step=0.015; 
mH= 1.007825; mO= 15.994910; mD = 2.014102;
M= mH + mO;

if len(sys.argv) != 5:
  print "Syntax: " + str(sys.argv[0]) + " <in_POSCAR> <O index>  <H index>  <out_POSCAR pattern>\n"
  sys.exit(2)

fin=   str(sys.argv[1])
Oin=  [int(sys.argv[2]) - 1]   # -1 to match python indexes
Hin=  [int(sys.argv[3]) - 1]   # -1 to match python indexes
fout=  str(sys.argv[4])


structure= read_vasp(fin)
cell= structure.get_cell()
natoms= len(structure)
#view(structure);

# Make list for elements of interest
indexO=    [i for i,x in enumerate(structure.get_chemical_symbols()) if x == 'O']  # O indexes
indexH=    [i for i,x in enumerate(structure.get_chemical_symbols()) if x == 'H']  # H indexes
indexX=    [i for i,x in enumerate(structure.get_chemical_symbols()) if x == 'W']  # Wannier (W) indexes


# Identify water molecules  =========================================================
nl_12= NeighborList([1.2/2]*len(structure),skin=0, self_interaction=False,bothways=True)
nl_12.build(structure)
indO_nH= [[i,len(np.intersect1d(nl_12.get_neighbors(i)[0],indexH))] for i in indexO ] # Array with O and corresponding H neighbors
indexOw= [indxO for (indxO,nH) in indO_nH if nH == 2]                                 # index of Ow
indexMol_w= [flatten([i,np.intersect1d(nl_12.get_neighbors(i)[0],flatten([indexH,indexX])).tolist()]) for i in indexOw ]     # Array with water molecules + wannier centers


# Put the O atom in the center of the box =============================================
if True :
  vCENTER=(structure.get_cell()[0]+structure.get_cell()[1]+structure.get_cell()[2])/2. # get translation vector to put the O in the center of the box
  structure.translate(-structure.get_positions()[Oin] + vCENTER)                       # center the O in the box
  structure.set_scaled_positions(structure.get_scaled_positions())                     # put back everything in the box

# Bring all waters together  ===============================================
if False:
  print "Bringing all waters together..."
  for i in indexOw:
    indices, offsets = nl_12.get_neighbors(i)
    for j, offset in zip(indices, offsets):
      structure.positions[j]= structure.positions[j] + np.dot(offset, cell)
#===============================================================================
structure_orig= copy.deepcopy(structure)


# For each Ow
#for iw in indexOw:
for iw in Oin:
  structure= copy.deepcopy(structure_orig)

  neighbors= nl_12.get_neighbors(iw)[0]          # get the H neighbors to Ow
  indexH_loc= np.intersect1d(neighbors,indexH)   # H belonging to the water molecule

  posO= structure_orig.get_positions()[iw]       # calculate the bisector (just in case)    
  vOH1= structure_orig.get_positions()[indexH_loc[0]] - posO
  vOH2= structure_orig.get_positions()[indexH_loc[1]] - posO
  vMid= (vOH1+vOH2); vMid= vMid/np.linalg.norm(vMid)

  #for iH in indexH_loc:
  for iH in Hin:
    posH= structure_orig.get_positions()[iH];
    vec_OH= posH - posO;
    unitV= vec_OH/np.linalg.norm(vec_OH)
    if np.linalg.norm(vec_OH) > 1.1:
      print "\nWARNING!!! rOH= {0} - this does not look correct!\n".format(np.linalg.norm(vec_OH))
      sys.exit(2)

    print "Preparing input for O: {0} + H: {1}  | rOH= {2}".format(iw+1,iH+1,np.linalg.norm(vec_OH))
    vel_tmp= np.zeros((natoms,3))
    toFix= range(natoms) # fix initially all atoms
    toFix.remove(iw);    toFix.remove(iH)

    vel_tmp[iw]= -(step/M*mH)*unitV;
    vel_tmp[iH]=  (step/M*mO)*unitV;

    structure.set_constraint(ase.constraints.FixAtoms(indices= toFix)) # fix all atoms
    structure.set_velocities(vel_tmp)
   
    dir=1.0;   # direction - _gt = stretch, _lt = unstretch
    for iff in ["_gt","_lt"]:
      foutV= fout + iff
      if dir==1.0 :
        print ">>   Stretch input saved in: {0}".format(foutV)
      else:
        print ">> unStretch input saved in: {0}".format(foutV)
        
      write_vasp(foutV,structure, direct=False, sort=None, symbol_count=None, long_format=True, vasp5=True)

      fp=open(foutV,"a")
      fp.write("Cartesian\n")
      for i in range(natoms):
        fp.write("  {0:20.16f}{1:20.16f}{2:20.16f}\n".format(vel_tmp[i,0]*dir,vel_tmp[i,1]*dir,vel_tmp[i,2]*dir))
      fp.close()
      dir= -1.0;



 
