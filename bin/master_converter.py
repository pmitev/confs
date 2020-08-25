#!/usr/bin/env python3
#
# Converts between between different structure formats supported by ASE.
# If the the output name is POSCAR it will use vasp5 format and reorders the
# atom types if provided.
#

import sys
from ase.io import read, write

old= sys.argv[1]  # Input filename
new= sys.argv[2]  # Output filename

structure= read(old)
natypes=   len(sys.argv)-3  # assumes that the rest is list of atom types in order

if natypes > 0:
  from ase import Atoms
  aindex=[]; atnum=[]; astring= ""

  for ia in range(natypes):
    at= sys.argv[ia + 3]     
    index_tmp= [i for i,x in enumerate(structure.get_chemical_symbols()) if x == at ] # find the indexes of atom type "at"
    aindex= aindex + index_tmp                                                        # build the sorted index
    atnum= atnum + [len(index_tmp)]                                                   # find out the number of "at"
    astring= astring + at + str(len(index_tmp))                                       # prepare the new structure formula string

  structure= Atoms(astring,positions=structure.positions[aindex],cell= structure.get_cell())  # build the reordered object 


# Write the structure into the new format (perhaps reordered) =====================================================================
if new == "POSCAR": 
  from ase.io.vasp import write_vasp
  write_vasp(new,structure, direct=False, sort=None, symbol_count=None, long_format=True, vasp5=True)   # write to VASP5 format file
else:
  write(new, structure)   
