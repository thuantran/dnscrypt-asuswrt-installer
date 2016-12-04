#!/bin/bash

case "$1" in
  arm)
    ARCH=arm
    ;;
  mips)
    ARCH=mipsel
    ;;
  *)
    echo "Need to specify platform arm/mips"
    exit 1
    ;;
esac

set -e
set -x
rm -rf ./dnscrypt
mkdir ./dnscrypt && cd ./dnscrypt

SODIUM_VER=1.0.11
DNSCRYPT_VER=1.7.0
BASE=`pwd`
SRC=$BASE/src
WGET="wget --prefer-family=IPv4 --no-check-certificate"
DEST=$BASE/opt
CC=${ARCH}-uclibc-gcc
CXX=${ARCH}-uclibc-g++
STRIP=${ARCH}-uclibc-strip
LDFLAGS="-L$DEST/lib"
CPPFLAGS="-I$DEST/include"
MAKE="make -j`nproc`"
CONFIGURE="./configure --prefix=/opt --host=${ARCH}-linux"
PATCHES=$(readlink -f $(dirname ${BASH_SOURCE[0]}))/patches
mkdir -p $SRC

############# ###############################################################
# LIBSODIUM # ###############################################################
############# ###############################################################

mkdir $SRC/libsodium && cd $SRC/libsodium
$WGET https://github.com/jedisct1/libsodium/releases/download/$SODIUM_VER/libsodium-$SODIUM_VER.tar.gz
tar zxvf libsodium-$SODIUM_VER.tar.gz
cd libsodium-$SODIUM_VER

CC=$CC \
CXX=$CXX \
LDFLAGS=$LDFLAGS \
CPPFLAGS=$CPPFLAGS \
$CONFIGURE \
--enable-minimal \
--disable-shared

$MAKE
make install DESTDIR=$BASE

############ ################################################################
# DNSCRYPT # ################################################################
############ ################################################################

mkdir $SRC/dnscrypt && cd $SRC/dnscrypt
$WGET https://download.dnscrypt.org/dnscrypt-proxy/dnscrypt-proxy-$DNSCRYPT_VER.tar.gz
tar zxvf dnscrypt-proxy-$DNSCRYPT_VER.tar.gz
cd dnscrypt-proxy-$DNSCRYPT_VER

CC=$CC \
CXX=$CXX \
CPPFLAGS=$CPPFLAGS \
LDFLAGS=$LDFLAGS \
$CONFIGURE

$MAKE LDFLAGS="$LDFLAGS"
make install DESTDIR=$BASE/dnscrypt
$STRIP $BASE/dnscrypt/opt/sbin/dnscrypt-proxy
