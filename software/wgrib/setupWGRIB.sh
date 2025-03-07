if [ ! -d "wgrib" ]; then
        mkdir wgrib && cd wgrib && wget https://www.ftp.cpc.ncep.noaa.gov/wd51we/wgrib/wgrib.tar
        tar -xvf wgrib.tar

else
        cd wgrib
fi

make -j
