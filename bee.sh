#!/bin/sh
# Clone BEE, do a poetry install and gather other important dependencies

. ./config.sh

# First pull the neo4j container down
mkdir -p $BEE_IMG_DIR
ch-image pull neo4j:3.5.22
ch-builder2tar -b ch-image neo4j:3.5.22 $BEE_IMG_DIR
GDB_IMG=$BEE_IMG_DIR/neo4j.tar.gz
mv $BEE_IMG_DIR/neo4j:3.5.22.tar.gz $GDB_IMG

git clone $BEE_REPO $BEE_REPO_PATH
if [ ! -d $BEE_VENV ]; then
	$PYTHON -m venv $BEE_VENV
	. $BEE_VENV/bin/activate
fi
cd $BEE_REPO_PATH
pip install --upgrade pip
pip install poetry
poetry install

# Write a test config
if [ -f $BEE_CONFIG ]; then
	cp $BEE_CONFIG $BEE_ROOT/bee.conf.`date +s`
fi
cp $BEE_ROOT
rm -rf $BEE_CONFIG
mkdir -p $HOME/.config/beeflow
cat >> $BEE_CONFIG <<EOF
[DEFAULT]
bee_workdir = $BEE_WORKDIR
workload_scheduler = Simple
use_archive = False

[task_manager]
listen_port = 8892
container_runtime = Charliecloud

[charliecloud]
image_mntdir = /tmp
chrun_opts = --cd $HOME
container_dir = $HOME/img

[graphdb]
hostname = localhost
dbpass = password
bolt_port = 7687
http_port = 7474
https_port = 7473
gdb_image = $GDB_IMG
gdb_image_mntdir = /tmp

[scheduler]
listen_port = 5600

[workflow_manager]
listen_port = 7233

[builder]
deployed_image_root = /tmp
container_output_path = /
container_type = charliecloud
EOF
