#!/usr/bin/python
import numpy as np
import os, sys
from scipy.interpolate import UnivariateSpline

fin= str(sys.argv[1])


[x,y]= np.loadtxt(fin,unpack=True)

spl= UnivariateSpline(x,y,k=4)
ys= spl(x)
y1= spl.derivative()(x)

for i in range(len(x)):
    print x[i],ys[i],y1[i]
