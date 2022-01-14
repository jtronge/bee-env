#!/bin/sh
# BEE environment file to be sourced

. ./config.sh
if [ -f $BEE_VENV/bin/activate ]; then
    . $BEE_VENV/bin/activate
    # printf "Missing venv, maybe BEE has not been installed yet\n" 1>&2
fi
# cd $BEE_ROOT/$BEE_NAME
