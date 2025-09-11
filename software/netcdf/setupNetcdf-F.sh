# Setup netcdf-fortran
if [ ! -d "netcdf-fortran" ]; then
	git clone git@github.com:Unidata/netcdf-fortran.git --branch v4.6.1 netcdf-fortran && cd netcdf-fortran

else
	cd netcdf-fortran
fi

export FCFLAGS="-w -fallow-argument-mismatch -O2"
export FFLAGS="-w -fallow-argument-mismatch -O2"

CPPFLAGS=-I${NETCDF_HOME}/include LDFLAGS=-L${NETCDF_HOME}/lib ./configure \
							--enable-netcdf-4 \
							--enable-parallel-tests \
							CC=mpicc FC=mpif90 F77=mpif90 \
							--prefix=$NETCDF_HOME

# compile and install
make -j && make install
