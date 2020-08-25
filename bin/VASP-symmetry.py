#!/usr/bin/python
import os,sys
from ase import Atoms
from ase.data import chemical_symbols
from ase.io.vasp import read_vasp_out, read_vasp, write_vasp
#from pyspglib import spglib
import spglib

# Version 2015.02.09


fin=   str(sys.argv[1])

try:
  symprec= float(sys.argv[2])
except:
  symprec= 1e-5

print "symprec: ",symprec

structure= read_vasp(fin)
cell= structure.get_cell()
natoms= len(structure)

spacegroup = spglib.get_spacegroup(structure, symprec= symprec)
print "\n================================\nSpacegroup found: ",spacegroup,"\n================================\n"

symmetry = spglib.get_symmetry(structure, symprec= symprec)
#print "Symmetry operations:\n", symmetry


dataset= spglib.get_symmetry_dataset(structure, symprec= symprec)
print dataset
#print dataset['international']

# equivalent positions  ==============================================================
if True:
  print "#GDIS Input\n=========   Equivalen positions  =================="
  print "single conv"
  print "\nvectors"
  for i in range(3):
    print "   {0:15.12f} {1:15.12f} {2:15.12f}".format(cell[i][0],cell[i][1],cell[i][2])
  print "\nfractional"
  list=[]
  for i in range(len(structure)):
    eatom= dataset['equivalent_atoms'][i]
    if eatom not in list:
      list.append(eatom)
    print "{0:>3}{1:<2}     {2:<10}  {3:<10} {4:<10}".format(structure.get_chemical_symbols()[i], eatom, structure.get_scaled_positions()[i][0], structure.get_scaled_positions()[i][1], structure.get_scaled_positions()[i][2])
  print "======================================================="

#Refine cell ========================================================================
if True:
  lattice, scaled_positions, numbers = spglib.refine_cell(structure, symprec= symprec)  
  print "\n#GDIS Input\n==============  Refined cell ======================"
  print "single conv"
  print "\nvectors"
  for i in range(3):
    print "   {0:15.12f} {1:15.12f} {2:15.12f}".format(lattice[i][0],lattice[i][1],lattice[i][2])
  print "\nfractional"
  for i in range(len(structure)):
    print "{0:>3}     {1:<10}  {2:<10} {3:<10}".format(chemical_symbols[numbers[i]], scaled_positions[i][0], scaled_positions[i][1], scaled_positions[i][2])
  print "======================================================="


# Primitive cell =====================================================================
if True:
  lattice, scaled_positions, numbers= spglib.find_primitive(structure, symprec= symprec) 
  
  print "\n#GDIS Input\n=============  Primitive cell  ===================="
  print "single conv"
  print "\nvectors"
  for i in range(3):
    print "   {0:15.12f} {1:15.12f} {2:15.12f}".format(lattice[i][0],lattice[i][1],lattice[i][2])
  print "\nfractional"
  for i in range(len(numbers)):
      print "{0:5}  {1:15.12f}  {2:15.12f} {3:15.12f}".format(chemical_symbols[numbers[i]],scaled_positions[i][0],scaled_positions[i][1],scaled_positions[i][2])
  print "======================================================="
