if [ ! -d "HRLDAS" ]; then
        git clone --recursive git@github.com:NCAR/hrldas.git --branch master HRLDAS && cd HRLDAS
        #git checkout a4f4a2c
        git checkout c4b5a54
else
	cd HRLDAS
fi

cp ../user_build_options hrldas/.
cd hrldas && make
