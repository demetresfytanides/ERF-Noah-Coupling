# Bash script for `jobrunner` to install AMReX

# Setup AMReX
if [ ! -d "WRF" ]; then
        git clone --recursive git@github.com:wrf-model/WRF.git WRF && cd WRF
else
	cd WRF
fi
