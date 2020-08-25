#!/usr/bin/python3
import numpy as np
import os,sys
from math import degrees, radians
from ase.neighborlist import *
from ase.data import covalent_radii
covalent_radii[11]=1.4 # decrease a bit the Na radious
from ase.io import read

RcutMol= 2.5

eV2au=0.0194469057312645;
ang2bohr= 1./0.52917721;
mH= 1.007825; mO= 15.994910; mD = 2.014102;


fin=      str(sys.argv[1])
ref_atom= int(sys.argv[2]) - 1

ss= read(fin)
structure= ss.repeat(3)
structure.wrap(center=structure.get_scaled_positions()[ref_atom])
structure.translate(-structure.get_positions()[ref_atom])

# Identify molecules based on the covalenr radius * xxxx  =========================================================
nl= NeighborList(covalent_radii[structure.get_atomic_numbers()]*1.15,skin=0, self_interaction=False,bothways=True)
nl.update(structure)

#================================================
def find_molecule(atom_index):
  pool= set([])
  diff= set([atom_index])
  while diff != set([]):
    new=[]
    for i in list(diff):
      new = new + nl.get_neighbors(i)[0].tolist()

    newpool= pool | set (new)
    diff   = newpool - pool
    pool = newpool
#    print diff
  return pool | set([atom_index])
#================================================

molecules= []
todo= set(range(len(structure)))
while todo != set([]):
  cluster= find_molecule(list(todo)[0])

  if len(cluster) > 0:
    cluster_xyz= structure.get_positions()[list(cluster)]
    cluster_xyz= cluster_xyz - cluster_xyz[0]

  todo= todo - cluster

  molecules.append(list(cluster))



#==============================================================
for i in range(len(molecules)):
  if ref_atom in molecules[i]:
    ref_mol= i
    break

neigh_mol=set([])
for i in molecules[ref_mol]:
  for j in range(len(molecules)):
    if j != ref_mol:
      for k in molecules[j]:
        if structure.get_distance(i,k,mic=True) < RcutMol:
          neigh_mol= neigh_mol | set([j])

# Print reference + neighboour molecule(s)
natoms= len(molecules[ref_mol])
for i in neigh_mol:
  natoms= natoms + len(molecules[i])
print("{}\n  xyz".format(natoms))

for i in molecules[ref_mol]:
  print( "{0:5s}{1:.12f} {2:.12f} {3:.12f}".format(structure.get_chemical_symbols()[i], structure[i].x, structure[i].y, structure[i].z ) )
for j in neigh_mol:
  for i in molecules[j]:
    print( "{0:5s}{1:.12f} {2:.12f} {3:.12f}".format(structure.get_chemical_symbols()[i], structure[i].x, structure[i].y, structure[i].z ) )

