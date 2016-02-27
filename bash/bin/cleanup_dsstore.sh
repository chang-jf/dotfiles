#!/bin/bash
# Recursively delete `.DS_Store` files
find . -type f -name '*.DS_Store' -ls -delete
find . -type f -name 'Thumbs.db' -ls -delete
find . -type f -name 'Picasa.ini' -ls -delete
