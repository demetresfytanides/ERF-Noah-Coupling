# Setup libxml2
if [ ! -d "libxml2" ]; then
	git clone git@github.com:GNOME/libxml2.git --branch v2.9.0 libxml2 && cd libxml2

else
	cd libxml2
fi

./autogen.sh --prefix=$LIBXML2_HOME CC=$MPICH_CC CXX=$MPICH_CXX

# compile and install
make -j && make install
