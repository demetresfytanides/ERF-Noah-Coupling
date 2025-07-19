# Setup netcdf-c
if [ ! -d "netcdf-c" ]; then
	git clone git@github.com:Unidata/netcdf-c.git --branch v4.9.2 netcdf-c && cd netcdf-c

else
	cd netcdf-c
fi

./configure --enable-netcdf-4 --enable-parallel4 --enable-shared CC=mpicc CXX=mpicxx --prefix=$NETCDF_HOME CPPFLAGS="$CPPFLAGS"

# compile and install
make -j && make install
