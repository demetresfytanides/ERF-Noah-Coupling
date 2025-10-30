# Load MPI module. This should be available as standard module on a cluster.
# If not, build your own MPI and update PATH, LD_LIBRARY_PATH

module load gcc-native/12.3
module load PrgEnv-gnu/8.5.0 
module load cray-python/3.11.5
module load cray-hdf5-parallel/1.12.2.9
module load cudatoolkit/
module load cray-netcdf-hdf5parallel/4.9.0.9
#module load cuda/12.4
export NETCDF_DIR=/opt/cray/pe/netcdf-hdf5parallel/4.9.0.9/gnu/12.3
#module load cmake
export MPICH_GPU_SUPPORT_ENABLED=1
# Set MPI_HOME by quering path loaded by site module
export MPI_HOME=$(which mpicc | sed s/'\/bin\/mpicc'//)
export CUDA_HOME=$(which nvcc | sed s/'\/bin\/nvcc'//)
# Path to parallel HDF5 installtion with fortran support
export HDF5_HOME=$(which h5pfc | sed s/'\/bin\/h5pfc'//)
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HDF5_HOME/GNU/12.3/lib
export C_INCLUDE_PATH=$C_INCLUDE_PATH:$HDF5_HOME/GNU/12.3/include

#export http_proxy="http://proxy.alcf.anl.gov:3128"
#export https_proxy="http://proxy.alcf.anl.gov:3128"
#export ftp_proxy="http://proxy.alcf.anl.gov:3128"

export MPICH_CC=gcc-12
export MPICH_CXX=g++-12
export MPICH_FC=gfortran-12
export MPICH_F90=gfortran-12
export PATH=$HOME/.local/bin:$HOME/local/cmake-3.28.3/bin:$PATH
