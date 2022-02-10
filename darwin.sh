#!/bin/sh
# Install a debug version of Slurm for testing BEE

TMP=/tmp
INSTALL_ROOT=$HOME/slurmrestd
NUMJOBS=4

mkdir -p $INSTALL_ROOT

# Install slurmrestd deps
HTTP_PARSER_PATH=$INSTALL_ROOT
mkdir -p $HTTP_PARSER_PATH
cd $TMP
git clone https://github.com/nodejs/http-parser.git
cd http-parser
make PREFIX=$HTTP_PARSER_PATH || exit 1
make PREFIX=$HTTP_PARSER_PATH install || exit 1

# json-c
JSON_C_PATH=$INSTALL_ROOT
mkdir -p $JSON_C_PATH
cd $TMP
# git clone https://github.com/json-c/json-c.git
curl -O -L https://github.com/json-c/json-c/archive/refs/tags/json-c-0.15-20200726.tar.gz
tar -xvf json-c-0.15-20200726.tar.gz
mv json-c-json-c-0.15-20200726 json-c
mkdir json-c-build
cd json-c-build
cmake ../json-c -DCMAKE_INSTALL_PREFIX=$JSON_C_PATH
make || exit 1
make test || exit 1
make install || exit 1

# Install Slurm
SLURM_URL=https://download.schedmd.com/slurm/slurm-21.08.5.tar.bz2
SLURM_TARBALL=`basename $SLURM_URL`
SLURM_SRC=`echo $SLURM_TARBALL | rev | cut -d'.' -f3- | rev`
mkdir -p $BEE_ROOT/slurm
cd $TMP
curl -O -L $SLURM_URL
tar -xvf $SLURM_TARBALL
cd $SLURM_SRC
SLURM_PATH=$INSTALL_ROOT
./configure --prefix=$SLURM_PATH \
            --with-http-parser=$HTTP_PARSER_PATH \
            --with-json=$JSON_C_PATH \
            --enable-slurmrestd || exit 1
make -j$NUMJOBS || exit 1
make install || exit 1
