#!/bin/sh
# Start munge ands slurm daemon

. ./env.sh

munged -F &
slurmctld -D &
slurmd -D &
