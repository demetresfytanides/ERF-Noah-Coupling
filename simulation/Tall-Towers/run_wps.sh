# cache the value of current working directory
NodeDir=$(realpath .)

mpirun -n 30 tmp_build_dir/Exec/MoistRegTests/WPS_and_Metgrid_Tests/erf_wps_test inputs_tall_towers
