#!/bin/bash
a
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
mkdir -p ./dnscrypt && cd ./dnscrypt

SODIUM_VER=1.0.12
DNSCRYPT_VER=1.9.4
HAVEGED_VER=1.9.1
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

rm -rf $BASE/dnscrypt
mkdir -p $SRC

############# ###############################################################
# LIBSODIUM # ###############################################################
############# ###############################################################

mkdir -p $SRC/libsodium && cd $SRC/libsodium
[ -f libsodium-$SODIUM_VER.tar.gz ] || $WGET https://github.com/jedisct1/libsodium/releases/download/$SODIUM_VER/libsodium-$SODIUM_VER.tar.gz
rm -rf libsodium-$SODIUM_VER
tar zxvf libsodium-$SODIUM_VER.tar.gz
cd libsodium-$SODIUM_VER

CC=$CC \
CXX=$CXX \
LDFLAGS=$LDFLAGS \
CPPFLAGS=$CPPFLAGS \
$CONFIGURE --disable-shared

$MAKE
make install DESTDIR=$BASE

############ ################################################################
# DNSCRYPT # ################################################################
############ ################################################################

mkdir -p $SRC/dnscrypt && cd $SRC/dnscrypt
[ -f dnscrypt-proxy-$DNSCRYPT_VER.tar.gz ] || $WGET https://download.dnscrypt.org/dnscrypt-proxy/dnscrypt-proxy-$DNSCRYPT_VER.tar.gz
rm -rf dnscrypt-proxy-$DNSCRYPT_VER
tar zxvf dnscrypt-proxy-$DNSCRYPT_VER.tar.gz
cd dnscrypt-proxy-$DNSCRYPT_VER

CC=$CC \
CXX=$CXX \
CPPFLAGS=$CPPFLAGS \
LDFLAGS=$LDFLAGS \
$CONFIGURE --disable-plugins

$MAKE LDFLAGS="$LDFLAGS"
make install DESTDIR=$BASE/dnscrypt
$STRIP $BASE/dnscrypt/opt/sbin/dnscrypt-proxy
cp $BASE/dnscrypt/opt/sbin/dnscrypt-proxy ~/Desktop

########### #################################################################
# HAVEGED # #################################################################
########### #################################################################

mkdir -p $SRC/haveged && cd $SRC/haveged
[ -f haveged-1.9.1.tar.gz ] || $WGET http://www.issihosts.com/haveged/haveged-1.9.1.tar.gz
rm -rf haveged-$HAVEGED_VER
tar zxvf haveged-$HAVEGED_VER.tar.gz
cd haveged-$HAVEGED_VER

CC=$CC \
CXX=$CXX \
CPPFLAGS=$CPPFLAGS \
LDFLAGS=$LDFLAGS \
$CONFIGURE --disable-shared

$MAKE LDFLAGS="$LDFLAGS"
make install DESTDIR=$BASE/dnscrypt
$STRIP $BASE/dnscrypt/opt/sbin/haveged
cp $BASE/dnscrypt/opt/sbin/haveged ~/Desktop
