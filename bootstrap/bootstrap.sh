#!/bin/bash

SRCDEST=${SRCDEST:-$PWD}
BOOTSTRAP=/tmp/bootstrap
FAKEROOT=1.31
LIBARCHIVE=`bsdtar --version | awk '{print $5}'`
PACMAN=4.0.3

set -e
set -x

bootstrap_fakeroot() {
  if [ ! -f $SRCDEST/fakeroot_$FAKEROOT.orig.tar.gz ]; then
    curl -q -Lv https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_$FAKEROOT.orig.tar.gz -o $SRCDEST/fakeroot_$FAKEROOT.orig.tar.gz
  fi
  tar xf $SRCDEST/fakeroot_$FAKEROOT.orig.tar.gz
  pushd fakeroot-$FAKEROOT
  CFLAGS="-Wno-implicit-function-declaration" ./configure --prefix=$BOOTSTRAP
  make
  make install
  popd
}

bootstrap_pacman() {
  if [ ! -f $SRCDEST/libarchive-$LIBARCHIVE.tar.gz ]; then
    curl -q -Lv http://www.libarchive.org/downloads/libarchive-$LIBARCHIVE.tar.gz -o $SRCDEST/libarchive-$LIBARCHIVE.tar.gz
  fi
  if [ ! -f $SRCDEST/pacman-$PACMAN.tar.gz ]; then
    curl -q -Lv https://sources.archlinux.org/other/pacman/pacman-$PACMAN.tar.gz -o $SRCDEST/pacman-$PACMAN.tar.gz
  fi
  tar xf $SRCDEST/libarchive-$LIBARCHIVE.tar.gz
  tar xf $SRCDEST/pacman-$PACMAN.tar.gz
  pushd pacman-$PACMAN
  patch -p0 < ../../pacman/csrutil.patch
  ./configure --prefix=$BOOTSTRAP CFLAGS="-I$PWD/../libarchive-$LIBARCHIVE/libarchive/" --without-openssl --without-gpgme --disable-shared
  make
  make install
  sed -i -e 's|^CheckSpace|#CheckSpace|g' $BOOTSTRAP/etc/pacman.conf
  popd
}

mkdir -p $SRCDEST

rm -rf $BOOTSTRAP
mkdir -p $BOOTSTRAP

pushd `dirname $0`
bootstrap_fakeroot
bootstrap_pacman

pushd ../fakeroot
bash bootstrap.sh
popd

pushd ../pacman
bash bootstrap.sh
popd

popd
