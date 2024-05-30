# Bash script for `jobrunner` to install Noah-MP

if [ ! -d "NOAH-MP" ]; then
	git clone --recursive git@github.com:akashdhruv/ERF --branch development NOAH-MP && cd NOAM-MP

	# checkout desired branch
	#git checkout 23.11

else
	cd ERF
fi
