# Setup netcdf-fortran
if [ ! -d "netcdf-fortran" ]; then
	git clone git@github.com:Unidata/netcdf-fortran.git --branch v4.4.0 netcdf-fortran && cd netcdf-fortran

else
	cd netcdf-fortran
fi

CPPFLAGS=-I${NETCDF_HOME}/include LDFLAGS=-L${NETCDF_HOME}/lib ./configure \
							--enable-parallel4 \
							CC=mpicc FC=mpif90 F77=mpif90 \
							--prefix=$NETCDF_HOME

# compile and install
make -j && make install
