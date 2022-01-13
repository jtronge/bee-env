#!/bin/sh
# Clone and install all of BEE's dependencies

. ./config.sh
. ./dep-env.sh

git clone $BEE_REPO
$PYTHON -m venv venv
. venv/bin/activate
cd $BEE_NAME
pip install --upgrade pip
pip install poetry
poetry install
