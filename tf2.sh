#!/bin/bash

if [ $1 ]; then
	image=$1
else
	image="jacobtruman/tf2server"
fi

container_name="tf2server"

install_location="/tf2server/serverfiles"

config_local="/tf2server/tf2-server.cfg"
config_path="${install_location}/tf/cfg/tf2-server.cfg"

maps_local="/tf2server/maps"
maps_path="${install_location}/tf/maps"

default_map="plr_highertower"
max_players="24"
ip="192.168.1.12"

# delete existing container
cmd="docker rm ${container_name}"
$cmd
# run new container
cmd="docker run --security-opt seccomp=unconfined --name=${container_name} -it -d --network=host -e TF2_SERVER_IP=${ip} -e TF2_DEFAULT_MAP=${default_map} -v ${config_local}:${config_path}:rw -v ${maps_local}:${maps_path}:rw ${image}"
$cmd