#!/bin/sh

BEE_ROOT=${BEE_ROOT:-$HOME/bee-env}
NUMJOBS=${NUMJOBS:-8}
TMP=${TMP:-/tmp}
BEE_REPO=${BEE_REPO:-git@github.com:lanl/BEE_Private.git}
BEE_NAME=${BEE_NAME:-BEE_Private}
PYTHON=${PYTHON:-python3.8}
SLURM_CONF=${SLURM_CONF:-$BEE_ROOT/slurm.conf}
