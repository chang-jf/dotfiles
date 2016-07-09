#!/bin/bash
# md5 checksum for all sub directorys, place in _md5Sum.md5 separately.
find "$PWD" -type d | sort | while read dir; do cd "${dir}"; [ ! -f _md5Sum.md5 ] && echo "Processing " "${dir}" || echo "Skipped " "${dir}" " _md5Sum.md5 allready present" ; [ ! -f _md5Sum.md5 ] &&  md5sum * > _md5Sum.md5 ; chmod a=r "${dir}"/_md5Sum.md5 ;done 
