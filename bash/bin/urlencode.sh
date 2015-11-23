#!/usr/bin/env python
# URL-encode strings
import sys, urllib as ul
print ul.quote_plus(sys.argv[1])
