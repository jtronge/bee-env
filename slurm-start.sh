#!/bin/sh

. ./env.sh

munged -F &
slurmctld -D &
slurmd -D &
