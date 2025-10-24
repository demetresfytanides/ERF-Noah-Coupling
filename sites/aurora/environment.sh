# Load MPI module. This should be available as standard module on a cluster.
# If not, build your own MPI and update PATH, LD_LIBRARY_PATH

module load mpich/opt/4.2.3-intel 
module load hdf5/1.14.6
module load python/3.10.14
module load cmake/3.31.8



# Set MPI_HOME by quering path loaded by site module
export MPI_HOME=$(which mpicc | sed s/'\/bin\/mpicc'//)

# Path to parallel HDF5 installtion with fortran support
export HDF5_HOME=$(which h5pfc | sed s/'\/bin\/h5pfc'//)
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HDF5_HOME/lib
export C_INCLUDE_PATH=$C_INCLUDE_PATH:$HDF5_HOME/include

export http_proxy="http://proxy.alcf.anl.gov:3128"
export https_proxy="http://proxy.alcf.anl.gov:3128"
export ftp_proxy="http://proxy.alcf.anl.gov:3128"

export MPICH_CC=icx
export MPICH_CXX=icpx
export MPICH_FC=ifx
export MPICH_F90=ifx
#export PATH=$HOME/.local/bin:$HOME/local/cmake-3.28.3/bin:$PATH
