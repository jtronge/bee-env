#!/bin/sh
# Start munge ands slurm daemon

. ./env.sh

echo $PATH
munged -F &
slurmctld -D &
slurmd -D &
