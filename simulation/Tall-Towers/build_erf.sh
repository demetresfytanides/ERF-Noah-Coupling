# cache the value of current working directory
NodeDir=$(realpath .)

rm -rf tmp_build_dir
mkdir -pv tmp_build_dir && cd tmp_build_dir

which cmake
cmake --version

export CRAYPE_LINK_TYPE="dynamic"

cmake -DCMAKE_INSTALL_PREFIX:PATH=./install \
   -DCMAKE_CXX_COMPILER:STRING=mpicxx \
   -DCMAKE_C_COMPILER:STRING=mpicc \
   -DCMAKE_Fortran_COMPILER:STRING=mpifort \
   -DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo \
   -DCMAKE_CUDA_HOST_COMPILER:STRING="$(which mpicxx)" \
   -DERF_DIM:STRING=3 \
   -DERF_ENABLE_MPI:BOOL=ON \
   -DERF_ENABLE_CUDA:BOOL=ON \
   -DERF_ENABLE_TESTS:BOOL=OFF \
   -DERF_ENABLE_FCOMPARE:BOOL=ON \
   -DERF_ENABLE_DOCUMENTATION:BOOL=OFF \
   -DERF_ENABLE_NETCDF:BOOL=ON \
   -DNETCDF_DIR=$NETCDF_HOME \
   -DERF_ENABLE_NOAHMP:BOOL=ON \
   -DERF_ENABLE_HDF5:BOOL=OFF \
   -DERF_ENABLE_EKAT:BOOL=ON \
   -DERF_ENABLE_KOKKOS:BOOL=ON \
   -DERF_ENABLE_RRTMGP:BOOL=ON \
   -DERF_ENABLE_NVHPC:BOOL=ON \
   -DCMAKE_PREFIX_PATH=/opt/nvidia/hpc_sdk/Linux_x86_64/24.5/cmake \
   -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=ON \
   $ERF_HOME && make -j
   #-DCMAKE_BUILD_TYPE=Debug \
   #-DCMAKE_CUDA_FLAGS="-I${MPI_HOME}/include" \
