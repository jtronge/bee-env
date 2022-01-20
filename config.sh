#!/bin/sh
# Important config variables
BEE_ROOT=${BEE_ROOT:-$HOME/bee-env}
BEE_WORKDIR=${BEE_WORKDIR:-$BEE_ROOT/beeflow}
NUMJOBS=${NUMJOBS:-8}
TMP=${TMP:-/tmp}
BEE_REPO=${BEE_REPO:-git@github.com:lanl/BEE_Private.git}
BEE_REPO_PATH=${BEE_REPO_PATH:-$BEE_ROOT/BEE_Private}
BEE_NAME=${BEE_NAME:-BEE_Private}
PYTHON=${PYTHON:-python3.8}
BEE_DEP_DIR=${BEE_DEP_DIR:-$BEE_ROOT/deps}
BEE_IMG_DIR=${BEE_IMG_DIR:-$BEE_ROOT/img}
BEE_VENV=${BEE_VENV:-$BEE_ROOT/venv}
BEE_CONFIG=$HOME/.config/beeflow/bee.conf
export SLURM_CONF=${SLURM_CONF:-$BEE_ROOT/slurm.conf}
export PATH=$BEE_DEP_DIR/bin:$BEE_DEP_DIR/sbin:$PATH
