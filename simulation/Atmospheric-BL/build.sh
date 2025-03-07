# cache the value of current working directory
NodeDir=$(realpath .)

#ERFSha="f97cda0460a6f30eea16a7b988569f4494c2181e"
#ERFSha="19de6a62"
#echo Using SHA: $ERFSha

cd $ERF_HOME #&& git checkout $ERFSha
cd Exec/ABL && cp $NodeDir/GNUmakefile . && make clean || true
NETCDF_DIR=$NETCDF_HOME && make -j && cp ERF3d.gnu.TEST.TPROF.MPI.ex $NodeDir
