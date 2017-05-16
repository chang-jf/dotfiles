#!/bin/bash
#Usage: upload_iso_to_pool.sh ISO POOL
warn() {
    echo "$1" >&2
}

die() {
    warn "$1"
    exit 1
}
[ -z $1 ] && die "Usage: upload_iso_to_pool.sh ISO POOL"
[ -z $2 ] && die "Usage: upload_iso_to_pool.sh ISO POOL"
iso_file=$1
pool_name=$2
iso_size=$(stat -Lc%s $1)
virsh vol-create-as $pool_name `basename $iso_file` $iso_size --format qcow2
virsh vol-upload --pool $pool_name `basename $iso_file` $iso_file 
