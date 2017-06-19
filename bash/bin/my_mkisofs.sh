#!/bin/bash
#This script pre-defined necessary option values for mkisofs
#Usage: my_mkisofs.sh iso_file_name folder_to_pack_into_iso
warn() {
    echo "$1" >&2
}

die() {
    warn "$1"
    exit 1
}
[ -z $1 ] && die "Usage: my_mkisofs.sh iso_file_name folder_to_pack_into_iso"
[ -z $2 ] && die "Usage: my_mkisofs.sh iso_file_name folder_to_pack_into_iso"

mkisofs -l -L -input-charset default -allow-lowercase -allow-multidot -o $1 $2
