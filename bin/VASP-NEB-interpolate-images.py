#!/usr/bin/python
# SYNTAX: VASP-NEB-interpolate-images.py  POSCAR.first  Nimages
#
from ase import io
from ase.neb import NEB
from ase.io.vasp import read_vasp_out, read_vasp, write_vasp
import sys, os
from ase.io.trajectory import PickleTrajectory
from ase.visualize import view

firstimage= sys.argv[1]
lastimage=  sys.argv[2]
Nstr=       sys.argv[3]

print "First image input: ",firstimage
print "Last  image input: ",lastimage
N= int(Nstr)
print "Number of images:",N
n= N+1

#N= int(lastimage.split(".")[1])
#print "Number of images: ",N

# Read initial and final states:

initial = read_vasp(sys.argv[1])
final   = read_vasp(sys.argv[2])

# Make a band consisting of 5 images:
images = [initial]
images += [initial.copy() for i in range(N-1)]
images += [final]
neb = NEB(images)

# Interpolate linearly the potisions of the three middle images:
neb.interpolate()

traj = PickleTrajectory('NEB.traj', 'w', backup=False)

for i in range(N+1):
  dirname= "{0:02d}".format(i)
  fname= "{0}/POSCAR".format(dirname)
  if not os.path.exists(dirname):
    os.makedirs(dirname)
  print fname
  write_vasp(fname,images[i], direct=True, sort=None, symbol_count=None, long_format=True, vasp5=True)
  traj.write(images[i])


#view(images)



