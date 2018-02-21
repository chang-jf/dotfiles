#!/bin/bash
CONTAINER_ID=$1
warn() {
    echo "$1" >&2
    echo ""
}

die() {
    warn "$1"
    exit 1
}
[ -z $1 ] && warn "Usage: mydock_nsenter.sh <Container_ID_To_Enter>" && docker ps -a && die

PID=$(sudo docker inspect --format "{{ .State.Pid }}" $1)
sudo nsenter --target $PID --mount --uts --ipc --net --pid
