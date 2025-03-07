if [ ! -d "cdo-2.1.1" ]; then
        #wget https://code.mpimet.mpg.de/attachments/download/28863/cdo-2.2.1.tar.gz
        tar -xvf cdo-2.1.1.tar
        cd cdo-2.1.1

else
        cd cdo-2.1.1
fi

./configure --prefix=$CDO_HOME --with-netcdf=$NETCDF_HOME CC=gcc CXX=g++ FC=gfortran \
            CPPFLAGS="-I/${NETCDF_HOME}/include" \
            LDFLAGS="-L/${NETCDF_HOME}/lib"

make -j
make install
