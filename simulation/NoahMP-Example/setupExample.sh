# cache the value of current working directory
NodeDir=$(realpath .)

# Setup AMReX
if [ ! -d "NoahMP-Example" ]; then
        git clone git@github.com:ESMWG/NoahMP-Example.git
fi

cd NoahMP-Example && cp $NodeDir/NoahMP/run/noahmp.exe .
