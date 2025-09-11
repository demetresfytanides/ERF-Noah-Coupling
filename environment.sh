# Bash file to load modules and set environment
# variables for compilers and external libraries

# Set project home using realpath
# of current directory
export PROJECT_HOME=$(realpath .)

# Set SiteHome to realpath of SiteName
SiteHome="$PROJECT_HOME/sites/$SiteName"

# Load modules from the site directory
source $SiteHome/environment.sh

# Path to ERF and AMReX
export ERF_HOME="$PROJECT_HOME/software/erf/ERF"
export AMREX_HOME="$ERF_HOME/Submodules/AMReX"
export MODEL_HOME="$PROJECT_HOME/models"
export NOAH_HOME="$ERF_HOME/Submodules/Noah-MP"
export NETCDF_HOME="$PROJECT_HOME/software/netcdf/netcdf-install-$SiteName"
export JASPER_HOME="$PROJECT_HOME/software/jasper/jasper-$SiteName"
export HRLDAS_HOME="$PROJECT_HOME/software/hrldas/HRLDAS"
export CDO_HOME="$PROJECT_HOME/software/cdo/cdo-install-$SiteName"
export WGRIB_HOME="$PROJECT_HOME/software/wgrib/wgrib"

export LD_LIBRARY_PATH="$JASPER_HOME/install/lib:$NETCDF_HOME/lib:$LD_LIBRARY_PATH"
export PATH="$WGRIB_HOME:$CDO_HOME/bin:$NETCDF_HOME/bin:$PATH"
export PKG_CONFIG_PATH="$NETCDF_HOME/lib/pkgconfig:$PKG_CONFIG_PATH"

# Path to parallel HDF5 installtion with fortran support
if [ $HDF5_HOME ]; then
	BuildHDF5=false
else
	BuildHDF5=true
	export HDF5_HOME="$PROJECT_HOME/software/hdf5/HDF5/install-$SiteName"
	export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HDF5_HOME/lib"
	export LIBRARY_PATH="$LD_LIBRARY_PATH"
fi

export LIBRARY_PATH="$LD_LIBRARY_PATH"

# Output information to stdout
echo "---------------------------------------------------------------------------------------"
echo "Execution Environment:"
echo "---------------------------------------------------------------------------------------"
echo "PROJECT_HOME=$PROJECT_HOME"
echo "SITE_HOME=$SiteHome"
echo "MPI_HOME=$MPI_HOME"
echo "HDF5_HOME=$HDF5_HOME"
echo "ERF_HOME=$ERF_HOME"
echo "AMREX_HOME=$AMREX_HOME"
echo "NOAH_HOME=$NOAH_HOME"
echo "MODEL_HOME=$MODEL_HOME"
echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
echo "NETCDF_HOME=$NETCDF_HOME"
echo "JASPER_HOME=$JASPER_HOME"
echo "HRLDAS_HOME=$HRLDAS_HOME"
echo "PATH=$PATH"
echo "---------------------------------------------------------------------------------------"
