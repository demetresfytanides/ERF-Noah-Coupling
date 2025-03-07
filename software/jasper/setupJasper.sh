if [ ! -d "jasper" ]; then
        git clone --recursive git@github.com:jasper-software/jasper.git --branch master jasper && cd jasper
        git checkout version-2.0.9 && cd ..
fi

cmake -H./jasper -B$JASPER_HOME/build -DCMAKE_INSTALL_PREFIX=$JASPER_HOME/install
cmake --build $JASPER_HOME/build --target install
