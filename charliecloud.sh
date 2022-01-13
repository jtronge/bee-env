#!/bin/sh

. ./config.sh

CH_URL=https://github.com/hpc/charliecloud/releases/download/v0.25/charliecloud-0.25.tar.gz
CH_TARBALL=`basename $CH_URL`
CH_SRC=`echo $CH_TARBALL | rev | cut -d'.' -f3- | rev`

mkdir -p $BEE_ROOT/charliecloud
cd $TMP
curl -O -L $CH_URL
tar -xvf $CH_TARBALL
cd $CH_SRC
./configure --prefix=$BEE_ROOT/charliecloud || exit 1
make || exit 1
make install || exit 1
