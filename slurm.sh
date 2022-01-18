#!/bin/sh
# Install a debug version of Slurm for testing BEE

. ./config.sh

mkdir -p $BEE_ROOT/etc
mkdir -p $BEE_ROOT/var

# Install PMIx
PMIX_PATH=$BEE_DEP_DIR
cd $TMP
# Only versions 1-3 work with Slurm right now
# curl -O -L https://github.com/openpmix/openpmix/releases/download/v4.1.0/pmix-4.1.0.tar.bz2
# tar -xvf pmix-4.1.0.tar.bz2
# cd pmix-4.1.0
curl -O -L https://github.com/openpmix/openpmix/releases/download/v3.2.3/pmix-3.2.3.tar.bz2
tar -xvf pmix-3.2.3.tar.bz2
cd pmix-3.2.3
./configure --prefix=$BEE_DEP_DIR --disable-man-pages --with-slurm
make -j$NUMJOBS || exit 1
make install || exit 1

# Install OpenMPI
cd $TMP
curl -O -L https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.2.tar.bz2
tar -xvf openmpi-4.1.2.tar.bz2
cd openmpi-4.1.2
./configure --prefix=$BEE_DEP_DIR \
            --with-pmix=$PMIX_PATH
            --with-ompi-pmix-rte \
            --with-slurm \
            --enable-mpi1-compatibility
make -j$NUMJOBS || exit 1
make install || exit 1

# Install slurmrestd deps
HTTP_PARSER_PATH=$BEE_DEP_DIR
mkdir -p $HTTP_PARSER_PATH
cd $TMP
git clone https://github.com/nodejs/http-parser.git
cd http-parser
make PREFIX=$HTTP_PARSER_PATH || exit 1
make PREFIX=$HTTP_PARSER_PATH install || exit 1
# json-c
JSON_C_PATH=$BEE_DEP_DIR
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

# Install MUNGE
MUNGE_URL=https://github.com/dun/munge/releases/download/munge-0.5.14/munge-0.5.14.tar.xz
MUNGE_TARBALL=`basename $MUNGE_URL`
MUNGE_SRC=`echo $MUNGE_TARBALL | rev | cut -d'.' -f3- | rev`
MUNGE_PATH=$BEE_DEP_DIR
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
SLURM_URL=https://download.schedmd.com/slurm/slurm-21.08.5.tar.bz2
SLURM_TARBALL=`basename $SLURM_URL`
SLURM_SRC=`echo $SLURM_TARBALL | rev | cut -d'.' -f3- | rev`
mkdir -p $BEE_ROOT/slurm
cd $TMP
curl -O -L $SLURM_URL
tar -xvf $SLURM_TARBALL
cd $SLURM_SRC
SLURM_PATH=$BEE_DEP_DIR
./configure --prefix=$BEE_DEP_DIR \
            --with-pmix=$PMIX_PATH \
            --with-munge=$MUNGE_PATH \
            --with-http-parser=$HTTP_PARSER_PATH \
            --with-json=$JSON_C_PATH \
            --enable-slurmrestd || exit 1
make -j$NUMJOBS || exit 1
make install || exit 1
