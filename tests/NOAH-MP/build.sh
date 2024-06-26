rm -rf tmp_build_dir
mkdir -pv tmp_build_dir && cd tmp_build_dir
cmake -DNETCDF_DIR=$NETCDF_ROOT $NOAH_HOME && make -j
