#!/bin/sh

. ./config.sh

CH_URL=https://github.com/hpc/charliecloud/releases/download/v0.26/charliecloud-0.26.tar.gz
CH_TARBALL=`basename $CH_URL`
CH_SRC=`echo $CH_TARBALL | rev | cut -d'.' -f3- | rev`

mkdir -p $BEE_DEP_DIR
cd $TMP
curl -O -L $CH_URL
tar -xvf $CH_TARBALL
cd $CH_SRC
./configure --prefix=$BEE_DEP_DIR || exit 1
make || exit 1
make install || exit 1
if [ ! -d $BEE_VENV ]; then
	$PYTHON -m venv $BEE_VENV || exit 1
fi
. $BEE_VENV/bin/activate
pip install --upgrade pip || exit 1
pip install requests || exit 1
