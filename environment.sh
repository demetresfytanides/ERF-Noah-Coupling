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
export NOAH_HOME="$ERF_HOME/Submodules/NOAH-MP"
export NETCDF_HOME="$PROJECT_HOME/software/netcdf/netcdf-install-$SiteName"

export LD_LIBRARY_PATH="$NETCDF_HOME/lib:$LD_LIBRARY_PATH"
export PATH="$NETCDF_HOME/bin:$PATH"

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
echo "PATH=$PATH"
echo "---------------------------------------------------------------------------------------"
