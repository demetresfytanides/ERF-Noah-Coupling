# cache the value of current working directory
NodeDir=$(realpath .)

ERFSha="f97cda0460a6f30eea16a7b988569f4494c2181e"

echo Using SHA: $ERFSha
cd $ERF_HOME && git checkout $ERFSha
cd Exec/ABL && make -j -DERF_EXPLICIT_MOST_STRESS && cp ERF3d.gnu.TEST.TPROF.MPI.ex $NodeDir
