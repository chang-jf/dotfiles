#!/bin/bash
cat /dev/urandom | hexdump -C | grep 'ca fe'           # show a table filled with meanless hex string, just for fun
