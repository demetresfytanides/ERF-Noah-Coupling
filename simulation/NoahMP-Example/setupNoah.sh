# cache the value of current working directory
NodeDir=$(realpath .)

# Setup AMReX
if [ ! -d "NoahMP" ]; then
        git clone git@github.com:esmwg/NoahMP
fi

export NETCDF=$NETCDF_HOME && cd NoahMP && ./configure && make && cd ..
