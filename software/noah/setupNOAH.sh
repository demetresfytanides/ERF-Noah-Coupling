# Bash script for `jobrunner` to install Noah-MP

if [ ! -d "NOAH-MP" ]; then
	git clone --recursive git@github.com:akashdhruv/noahmp.git --branch master NOAH-MP && cd NOAH-MP

	# checkout desired branch
	#git checkout 23.11

else
	cd NOAH-MP
fi
