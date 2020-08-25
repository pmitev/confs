#!/usr/bin/python
from ase import __version__
import sys
from ase import Atoms
from ase.io import write
#from ulm import ulmopen
import imp
ulm= imp.load_source("ulmopen", "/home/pmitev/bin/ulm.py")


fin=   str(sys.argv[1])
trajf= ulm.ulmopen(fin)

#print "ASE: "+ __version__
#print "steps: " + str(len(trajf))


for i in xrange(len(trajf)):
    structure=Atoms(numbers=    trajf.numbers,
                    positions=  trajf[i].positions,
                    pbc=        trajf.pbc,
                    cell=       trajf[i].cell)
    write("-",structure,format="xyz",comment="xyz",columns=(['symbols', 'positions']))

