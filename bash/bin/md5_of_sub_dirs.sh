#!/bin/bash
# md5 checksum of all sub directorys, place in ./_md5Sum.md5
find "$PWD" -type d | sort | while read dir; do md5sum "${dir}"/* >> ./_md5Sum.md5 ; done 
