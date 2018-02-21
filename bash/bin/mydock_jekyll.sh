#!/bin/bash
export JEKYLL_VERSION=3.5
sudo docker run --rm \
  --volume=$PWD:/srv/jekyll \
  -it jekyll/builder:$JEKYLL_VERSION \
  jekyll build
