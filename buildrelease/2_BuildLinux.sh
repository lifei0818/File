#!/bin/sh

BASEDIR=$PWD
export OUTDIR=$BASEDIR/linuxfv
export OUTDIRDEBUGINFO=$BASEDIR/linuxfv-debuginfo
rm -rf $OUTDIR
mkdir $OUTDIR
rm -rf $OUTDIRDEBUGINFO
mkdir $OUTDIRDEBUGINFO

PLATFORM=`uname -i`

case "$PLATFORM" in
   i386)
        echo "i386 platform!"   
        export CC=gcc
        export CFLAGS=-fPIC
        export CXX=g++
        export CXXFLAGS=-fPIC
        export LDFLAGS=
        export SYSLIBDIR=/usr/lib
        export SYSLIB="-lpthread -lrt -ldl -lz -lc"
        export AR=ar
        export ARFLAGS=crv
        ;;
   x86_64)
        echo "x86_64 platform!"   
        export CC=gcc
        export CFLAGS=-fPIC
        export CXX=g++
        export CXXFLAGS=-fPIC
        export LDFLAGS=
        export SYSLIBDIR=/usr/lib
        export SYSLIB="-lpthread -lrt -ldl -lz -lc"
        export AR=ar
        export ARFLAGS=crv
        ;;
		
   mips64)
        echo "mips64 platform!"   
        export CC=gcc
        export CFLAGS=-fPIC
        export CXX=g++
        export CXXFLAGS=-fPIC
        export LDFLAGS=
        export SYSLIBDIR=/usr/lib
        export SYSLIB="-lpthread -lrt -ldl -lz -lc"
        export AR=ar
        export ARFLAGS=crv
        ;;
   aarch64)
        echo "aarch64 platform!"   
        export CC=gcc
        export CFLAGS="-mabi=lp64 -fPIC -Wformat=0"
        export CXX=g++
        export CXXFLAGS="-mabi=lp64 -fPIC -Wformat=0 -fpermissive"
        export LDFLAGS="-mabi=lp64"
        export SOFLAGS="-mabi=lp64 -fPIC"
        export SYSLIBDIR=/usr/lib
        export SYSLIB="-lpthread -lrt -ldl -lz -lc"
        export AR=ar
        export ARFLAGS=crv
        ;;
   *)
        echo "Unknown platform!"
        echo "As i386 platform!"   
        export CC=gcc
        export CFLAGS=-fPIC
        export CXX=g++
        export CXXFLAGS=-fPIC
        export LDFLAGS=
        export SYSLIBDIR=/usr/lib
        export SYSLIB="-lpthread -lrt -ldl -lz -lc"
        export AR=ar
        export ARFLAGS=crv
        ;;
esac


export BASELIBDIR=$BASEDIR/BaseLib/BaseLib


#export CXXFLAGS=
export CXXFLAGS="$CXXFLAGS -g"


# cd BaseLib/BaseLib/ywSMPpub/
# ./version.sh
# cd ../../../

DIRS="\
$BASEDIR/BaseLib/BaseLib \
$BASEDIR/NewNetDrive/NewNetDrive \
$BASEDIR/nacslm"

for DIR in $DIRS
do
echo DIR=$DIR
    cd $DIR;make clean && make all && make clean
    if [ $? -ne 0 ]; then
        exit 1
    fi
done

cd $OUTDIR
for ONEFILE in *
do
	objcopy --only-keep-debug ${ONEFILE} ${ONEFILE}.debug
	objcopy --strip-debug ${ONEFILE}
#	strip -S ${ONEFILE}
	objcopy --add-gnu-debuglink=${ONEFILE}.debug ${ONEFILE}
	mv ${ONEFILE}.debug ${OUTDIRDEBUGINFO}/${ONEFILE}.debug
	# read
	# objdump -s -j .gnu_debuglink ywSMPAgent
done

cd $BASEDIR

