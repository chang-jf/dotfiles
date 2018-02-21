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
[ -z $1 ] && warn "Usage: mydock_ls-mounted-volumes.sh <Container_ID_To_Enter>" && docker ps -a && die

docker inspect -f '{{ (index .Mounts 0).Source }}' $1
