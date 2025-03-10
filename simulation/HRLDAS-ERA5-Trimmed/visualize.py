import numpy as np
import matplotlib.pyplot as plt
from netCDF4 import Dataset

### Read in data
datain = Dataset("./LDASOUT/2023110201.LDASOUT_DOMAIN1","r")
LHin = datain.variables["LH"][:]
print(np.shape(LHin))

hour_str = ["00","01","02","03","04","05","06","07","08","09",
            "10","11","12","13","14","15","16","17","18","19",
            "20","21","22","23"]

for h in range(24):
    fig = plt.figure(figsize=(5,5))
    plt.contourf(LHin[h,:,:],levels=np.linspace(0,300,21),cmap="jet",extend="both")
    plt.title("LH @ 2023-11-01_"+hour_str[h])
    plt.savefig("./LDASOUT/ERA5-Land_Noah-MP_LH_2023-11-02_"+hour_str[h]+".png")
