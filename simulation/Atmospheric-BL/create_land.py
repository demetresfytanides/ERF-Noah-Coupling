from netCDF4 import Dataset
import numpy as np

prob_extent = [1024, 1024]
n_cell = [64, 64]

# Create NetCDF file
ncfile = Dataset("flat_land.nc", "w", format="NETCDF4")

ncfile.title = "ERF-Flat-Land"
ncfile.source = "Synthetic dataset for ERF model testing"
ncfile.DX = prob_extent[0] / n_cell[0]
ncfile.DY = prob_extent[1] / n_cell[1]
ncfile.LLANDUSE = "MODIFIED_IGBP_MODIS_NOAH"
ncfile.ISWATER = 17
ncfile.ISLAKE = -1
ncfile.ISURBAN = 13
ncfile.ISICE = 15

# Define dimensions
ncfile.createDimension("NX", n_cell[0])
ncfile.createDimension("NY", n_cell[1])

# Create variables
TERRAIN = ncfile.createVariable("TERRAIN", "f4", ("NX", "NY"))
ISLTYP = ncfile.createVariable("ISLTYP", "i4", ("NX", "NY"))
SMOIS = ncfile.createVariable("SMOIS", "f4", ("NX", "NY"))
TSLB = ncfile.createVariable("TSLB", "f4", ("NX", "NY"))
LAI = ncfile.createVariable("LAI", "f4", ("NX", "NY"))
VEGFRA = ncfile.createVariable("VEGFRA", "f4", ("NX", "NY"))
SNOW = ncfile.createVariable("SNOW", "f4", ("NX", "NY"))
SNOWH = ncfile.createVariable("SNOWH", "f4", ("NX", "NY"))

# Assign flat terrain values
TERRAIN[:, :] = 0.0  # Terrain
ISLTYP[:, :] = 3  # Example: Sandy Loam
SMOIS[:, :] = 0.2  # Initial soil moisture (m³/m³)
TSLB[:, :] = 280.0  # Initial soil temperature (K)
LAI[:, :] = 1.0  # Moderate vegetation
VEGFRA[:, :] = 0.5  # 50% vegetation cover
SNOW[:,:] = 1.0
SNOWH[:,:] = 0.05

# Close file
ncfile.close()
print("NetCDF file 'flat_land.nc' created successfully.")
