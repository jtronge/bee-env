#!/bin/sh

. ./config.sh

PYTHON_URL=https://www.python.org/ftp/python/3.8.12/Python-3.8.12.tar.xz
PYTHON_TARBALL=`basename $PYTHON_URL`
PYTHON_SRC=`echo $PYTHON_TARBALL | rev | cut -d'.' -f3- | rev`

mkdir -p $BEE_ROOT/python
cd $TMP
curl -O -L $PYTHON_URL
tar -xvf $PYTHON_TARBALL
cd $PYTHON_SRC
./configure --prefix=$BEE_ROOT/python --enable-optimizations || exit 1
make -j$NUMJOBS || exit 1
make install || exit 1
