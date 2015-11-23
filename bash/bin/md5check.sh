#!/bin/bash
# md5check [file] [key]
md5sum "$1" | grep "$2";
