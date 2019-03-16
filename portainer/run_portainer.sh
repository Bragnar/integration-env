#!/bin/bash



IMAGE="portainer/portainer:latest"
NAME="portainer-service"
VOLUMES=([DOCKER_SOCK]="/var/run/docker.sock:/var/run/docker.sock")
PORTS=([WEB]="9000:9000")


ADMIN_PASSWD='$2y$05$n5U4.hvmhkwFBTMLkE.EveSuaXxlbQheT6Y3ISA6I9V2kO7u7dHce'
ARGS+="--admin-password ${ADMIN_PASSWD}"

set -x
docker run --name ${NAME} -p ${PORTS[WEB]} -v ${VOLUMES[DOCKER_SOCK]}  -d $IMAGE ${ARGS}
set +x

exit $?
