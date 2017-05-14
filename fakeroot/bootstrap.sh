#!/bin/bash

set -e
set -x

BOOTSTRAP=/tmp/bootstrap
export PATH=$PATH:$BOOTSTRAP/bin

pushd `dirname $0`
makepkg -d -f

DBPATH=/usr/local/var/lib/pacman
sudo mkdir -p $DBPATH
sudo pacman -b $DBPATH -Uf fakeroot-*.pkg.tar.*
popd
