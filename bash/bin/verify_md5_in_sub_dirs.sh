#!/bin/bash
#verify md5 checksum for all sub directories one by one.
find "$PWD" -name _md5Sum.md5 | sort | while read file; do cd "${file%/*}"; md5sum -c _md5Sum.md5; done > /tmp/checklog.txt
