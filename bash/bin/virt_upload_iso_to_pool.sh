#!/bin/bash
#Usage: upload_iso_to_pool.sh ISO POOL VOL
warn() {
    echo "$1" >&2
}

die() {
    warn "$1"
    exit 1
}
[ -z $1 ] && die "Usage: upload_iso_to_pool.sh ISO POOL VOL"
[ -z $2 ] && die "Usage: upload_iso_to_pool.sh ISO POOL VOL"
[ -z $3 ] && die "Usage: upload_iso_to_pool.sh ISO POOL VOL"
iso_file=$1
pool_name=$2
vol_name=$3
iso_size=$(stat -Lc%s $1)
sudo virsh vol-create-as $pool_name $vol_name $iso_size --format qcow2
sudo virsh vol-upload --pool $pool_name $vol_name $iso_file 
