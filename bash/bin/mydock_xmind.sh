#!/bin/bash
IMAGES_TO_RUN=$1
SPECIFIED_TARGET=$2
warn() {
    echo "$1" >&2
    echo ""
}

die() {
    warn "$1"
    exit 1
}
[ -z $1 ] && warn "Usage: mydock.sh IMAGE_TO_RUN" && sudo docker images && die

sudo docker run -ti --rm -e DISPLAY=$DISPLAY -e SPECIFIED_TARGET=$SPECIFIED_TARGET -v /tmp/.X11-unix:/tmp/.X11-unix -v $PWD:/mnt -w /mnt xmind
