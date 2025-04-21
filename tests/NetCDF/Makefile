all:
	mpif90 write_parallel.f90 -o write_parallel \
				  -I${NETCDF_HOME}/include \
				  -L${NETCDF_HOME}/lib -lnetcdff -lnetcdf

clean:
	rm write_parallel parallel_data.nc
