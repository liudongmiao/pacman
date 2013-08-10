#!/bin/bash

SRCDEST=${:$PWD}
BOOTSTRAP=/tmp/bootstrap
FAKEROOT=1.19
LIBARCHIVE=`bsdtar --version | awk '{print $5}'`
PACMAN=4.0.3

set -e
set -x
bootstrap_fakeroot() {
  if [ ! -f $SRCDEST/fakeroot_$FAKEROOT.orig.tar.bz2 ]; then
    curl -Lv http://ftp.debian.org/debian/pool/main/f/fakeroot/fakeroot_$FAKEROOT.orig.tar.bz2 -o $SRCDEST/fakeroot_$FAKEROOT.orig.tar.bz2
  fi
  tar xf $SRCDEST/fakeroot_$FAKEROOT.orig.tar.bz2
  pushd fakeroot-$FAKEROOT
  ./configure --prefix=$BOOTSTRAP
  make
  make install
  popd
}

bootstrap_pacman() {
  if [ ! -f $SRCDEST/pacman-$PACMAN.tar.gz ]; then
    curl -Lv https://github.com/downloads/libarchive/libarchive/libarchive-$LIBARCHIVE.tar.gz -o $SRCDEST/libarchive-$LIBARCHIVE.tar.gz
    curl -Lv ftp://ftp.archlinux.org/other/pacman/pacman-$PACMAN.tar.gz -o $SRCDEST/pacman-$PACMAN.tar.gz
  fi
  tar xf $SRCDEST/libarchive-$LIBARCHIVE.tar.gz
  tar xf $SRCDEST/pacman-$PACMAN.tar.gz
  pushd pacman-$PACMAN
  ./configure --prefix=$BOOTSTRAP CFLAGS="-I$PWD/../libarchive-$LIBARCHIVE/libarchive/" LDFLAGS="-lcrypto" --disable-shared
  make
  make install
  popd
}

mkdir -p $SRCDEST

rm -rf $BOOTSTRAP
mkdir -p $BOOTSTRAP

bootstrap_fakeroot
bootstrap_pacman
