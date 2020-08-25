#!/usr/bin/python
import numpy as np
import sys
from scipy.interpolate import UnivariateSpline


fin= str(sys.argv[1])
nval= len(sys.argv) - 2 # Number or points to evaluate the function

[x,y]= np.loadtxt(fin,unpack=True)

spl= UnivariateSpline(x,y,k=4)

for i in range(nval):
    val= float(sys.argv[i+2])
    print val, spl(val)

