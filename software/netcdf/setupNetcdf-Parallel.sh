# Setup netcdf-c
if [ ! -d "pnetcdf" ]; then
        git clone git@github.com:Parallel-NetCDF/PnetCDF.git pnetcdf && cd pnetcdf
        git checkout checkpoint.1.12.0
else
	cd pnetcdf
fi

autoreconf -i
./configure --prefix=$NETCDF_HOME MPICC=mpicc MPICXX=mpicxx MPIF77=mpif90 MPIF90=mpif90

# compile and install
make -j && make install
