#!/bin/bash
#52:54:00 for QEMU
#00:16:3e for Xen
hexdump -vn3 -e '/3 "52:54:00"' -e '/1 ":%02x"' -e '"\n"' /dev/urandom
