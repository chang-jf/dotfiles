#!/bin/bash
IMAGE_TAG_NAME=$1
warn() {
    echo "$1" >&2
    echo ""
}

die() {
    warn "$1"
    exit 1
}
[ -z $1 ] && warn "Usage: mydock_GENERATE.sh TAG_NAME_FOR_DOCKER_IMAGES" && sudo docker images && die

sudo docker build -t $IMAGE_TAG_NAME .
