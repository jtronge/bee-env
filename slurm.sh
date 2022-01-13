#!/bin/sh

. ./config.sh

mkdir -p $BEE_ROOT/etc
mkdir -p $BEE_ROOT/var

# Install slurmrestd deps
HTTP_PARSER_PATH=$BEE_ROOT/http-parser
mkdir -p $HTTP_PARSER_PATH
cd $TMP
git clone https://github.com/nodejs/http-parser.git
cd http-parser
make PREFIX=$HTTP_PARSER_PATH || exit 1
make PREFIX=$HTTP_PARSER_PATH install || exit 1
# json-c
JSON_C_PATH=$BEE_ROOT/json-c
mkdir -p $JSON_C_PATH
cd $TMP
git clone https://github.com/json-c/json-c.git
mkdir json-c-build
cd json-c-build
cmake ../json-c -DCMAKE_INSTALL_PREFIX=$JSON_C_PATH

# Install MUNGE
MUNGE_URL=https://github.com/dun/munge/releases/download/munge-0.5.14/munge-0.5.14.tar.xz
MUNGE_TARBALL=`basename $MUNGE_URL`
MUNGE_SRC=`echo $MUNGE_TARBALL | rev | cut -d'.' -f3- | rev`
MUNGE_PATH=$BEE_ROOT/munge
mkdir -p $MUNGE_PATH
cd $TMP
curl -O -L $MUNGE_URL
tar -xvf $MUNGE_TARBALL
cd $MUNGE_SRC
./configure --prefix=$MUNGE_PATH \
            --sysconfdir=$BEE_ROOT/etc \
            --localstatedir=$BEE_ROOT/var || exit 1
make || exit 1
# make check
make install || exit 1

# Install Slurm
SLURM_URL=https://download.schedmd.com/slurm/slurm-20.11.8.tar.bz2
SLURM_TARBALL=`basename $SLURM_URL`
SLURM_SRC=`echo $SLURM_TARBALL | rev | cut -d'.' -f3- | rev`
mkdir -p $BEE_ROOT/slurm
cd $TMP
curl -O -L $SLURM_URL
tar -xvf $SLURM_TARBALL
cd $SLURM_SRC
./configure --prefix=$BEE_ROOT/slurm \
            --with-munge=$MUNGE_PATH \
            --with-http-parser=$HTTP_PARSER_PATH \
            --with-json=$JSON_C_PATH \
            --enable-slurmrestd || exit 1
make -j$NUMJOBS || exit 1
make install || exit 1
