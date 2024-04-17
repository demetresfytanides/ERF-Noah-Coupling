# Bash script for `jobrunner` to install AMReX

# Setup AMReX
if [ ! -d "ERF" ]; then
	git clone --recursive git@github.com:akashdhruv/ERF --branch development ERF && cd ERF

	# checkout desired branch
	#git checkout 23.11

else
	cd ERF
fi
