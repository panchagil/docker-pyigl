#!/bin/bash
container=opengl
image=gilureta/opengl
port=6080
extra_run_args=""
quiet=""

show_help() {
cat << EOF
Usage: ${0##*/} [-h] [-q] [-c CONTAINER] [-i IMAGE] [-p PORT] [-r DOCKER_RUN_FLAGS]

This script is a convenience script to run Docker images based on
thewtex/opengl. It:

- Makes sure docker is available
- On Windows and Mac OSX, creates a docker machine if required
- Informs the user of the URL to access the container with a web browser
- Stops and removes containers from previous runs to avoid conflicts
- Mounts the present working directory to /home/user/work on Linux and Mac OSX
- Prints out the graphical app output log following execution
- Exits with the same return code as the graphical app

Options:

  -h             Display this help and exit.
  -c             Container name to use (default ${container}).
  -i             Image name (default ${image}).
  -p             Port to expose HTTP server (default ${port}). If an empty
                 string, the port is not exposed.
  -d             Extra arguments to pass to 'docker run'. E.g.
                 --env="APP=glxgears"
  -q             Do not output informational messages.
EOF
}

while [ $# -gt 0 ]; do
	case "$1" in
		-h)
			show_help
			exit 0
			;;
		-c)
			container=$2
			shift
			;;
		-i)
			image=$2
			shift
			;;
		-p)
			port=$2
			shift
			;;
		-d)
			extra_docker_args="$extra_docker_args $2"
			shift
			;;
		-r)
			extra_run_args="$extra_run_args $2"
			shift
			;;
		-q)
			quiet=1
			;;
		*)
			show_help >&2
			exit 1
			;;
	esac
	shift
done


which docker 2>&1 >/dev/null
if [ $? -ne 0 ]; then
	echo "Error: the 'docker' command was not found.  Please install docker."
	exit 1
fi

ip="localhost"
url="http://${ip}:$port"

cleanup() {
	echo "cleanup"
    docker stop $container >/dev/null
	docker rm $container >/dev/null
}

running=$(docker ps -a -q --filter "name=${container}")
if [ -n "$running" ]; then
	if [ -z "$quiet" ]; then
		echo "Stopping and removing the previous session..."
		echo ""
	fi
	cleanup
fi

if [ -z "$quiet" ]; then
	echo ""
	echo "Setting up the graphical application container..."
	echo ""
	if [ -n "$port" ]; then
		echo "Point your web browser to ${url}"
		echo ""
	fi
fi

port_arg=""
if [ -n "$port" ]; then
	port_arg="-p $port:6080"
fi

docker run \
  -d \
  --name $container \
  --mount type=bind,source="$(pwd)",target=/workspace \
  $port_arg \
  $extra_docker_args \
  $image \
  $extra_run_args

print_app_output() {
	docker cp $container:/var/og/supervisor/graphical-app-launcher.log - \
		| tar xO
	result=$(docker cp $container:/tmp/graphical-app.return_code - \
		| tar xO)
	cleanup
	exit $result
}

trap "docker stop $container >/dev/null && print_app_output" SIGINT SIGTERM
docker exec -it $container bash

echo "Stopping container $container (it might take a while)"
docker stop $container > /dev/null 

print_app_output