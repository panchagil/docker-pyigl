#!/bin/sh

script_dir="`cd $(dirname $0); pwd`"

$script_dir/glrun.sh -i gilureta/pyigl -p 6081 -d "--workdir /setup/libigl/python/" -r "$@"
