#!/bin/sh

. ./config.sh
. ./dep-env.sh
if [ ! -f venv/bin/activate ]; then
    printf "Missing venv, maybe BEE has not been installed yet\n" 1>&2
fi
. ./venv/bin/activate
cd $BEE_ROOT/$BEE_NAME
