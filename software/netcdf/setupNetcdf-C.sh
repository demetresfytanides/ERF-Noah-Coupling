# Setup netcdf-c
if [ ! -d "netcdf-c" ]; then
	git clone git@github.com:Unidata/netcdf-c.git --branch v4.4.0 netcdf-c && cd netcdf-c

else
	cd netcdf-c
fi

./configure --enable-parallel4 CC=mpicc CXX=mpicxx --prefix=$NETCDF_HOME

# compile and install
make -j && make install
