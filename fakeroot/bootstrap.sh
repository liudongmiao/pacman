#!/bin/bash

set -e
set -x

BOOTSTRAP=/tmp/bootstrap
export PATH=$PATH:$BOOTSTRAP/bin

makepkg

DBPATH=/usr/local/var/lib/pacman
sudo mkdir -p $DBPATH
sudo pacman -b $DBPATH -Uf fakeroot-*.pkg.tar.*
