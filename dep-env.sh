#!/bin/sh
# Load BEE's external dependencies (Python 3.8, Charliecloud, etc.)

. ./config.sh

export PATH=$BEE_ROOT/python/bin:$BEE_ROOT/slurm/bin:$BEE_ROOT/slurm/sbin:$BEE_ROOT/charliecloud/bin:$BEE_ROOT/munge/bin:$BEE_ROOT/munge/sbin:$PATH
