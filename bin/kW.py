#!/usr/bin/env python3
import pandas as pd
import matplotlib.pyplot as plt
import os

script_path = os.path.dirname(__file__)

try:
  __IPYTHON__
  plt.interactive(True)
except:
  print ("")  

data= pd.read_csv(script_path + "/kW.csv", index_col=0)

plt.style.use('seaborn')
data.T.plot(kind="bar")
data.mean().plot(linestyle=":",lw=1)
#data.loc[2015:2017].T.plot.bar()

plt.xlim([-0.5,11.5])
plt.title("Electricity")
plt.ylabel("kW")
plt.show()



