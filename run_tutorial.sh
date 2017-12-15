#!/bin/sh

script_dir="`cd $(dirname $0); pwd`"
$script_dir/glrun.sh -i gilureta/pyigl -p 6081 -d "--workdir /setup/libigl/python/" -r "$@"
# If you use docker-machine use this line instead 
# $script_dir/glrun.sh -m -i gilureta/pyigl -p 6081 -d "--workdir /setup/libigl/python/" -r "$@"

