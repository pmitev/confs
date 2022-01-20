#!/usr/bin/env python3
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import os

script_path = os.path.dirname(__file__)

try:
  __IPYTHON__
  plt.interactive(True)
except:
  print ("")  

plt.style.use('seaborn')

data= pd.read_csv(script_path + "/EL.csv", index_col=0,parse_dates=True)
data.index= pd.to_datetime(data.index)
pd.set_option('max_rows', None)
print ( data.groupby(by=[data.index.year,data.index.month]).sum() )
print ( data.groupby(by=[data.index.year]).sum() )



data.plot(kind="bar")
plt.ylabel("kW")

plt.show()


