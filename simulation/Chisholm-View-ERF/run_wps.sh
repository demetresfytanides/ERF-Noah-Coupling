# cache the value of current working directory
NodeDir=$(realpath .)

mpirun -n 1 tmp_build_dir/Exec/MoistRegTests/WPS_Test/erf_wps_test inputs_real_ChisholmView 
