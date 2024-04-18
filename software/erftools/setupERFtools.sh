# Bash script for `jobrunner` to install erftools

if [ ! -d "erftools" ]; then
	git clone --recursive git@github.com:erf-model/erftools.git --branch main erftools && cd erftools
else
	cd erftools
fi
