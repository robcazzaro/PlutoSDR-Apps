#!/bin/bash

set -e

# note: sysroot up to 0.29 needs a soft-float compiler, sysroot 0.30 and above a hard-float compiler
#PLUTOSDRFW=${PLUTOSDRFW:-v0.29}
PLUTOSDRFW=${PLUTOSDRFW:-v0.34}
#VENDOR=xilinx-
#CROSS_COMPILE=arm-${VENDOR}linux-gnueabi-
#TARGET=${TARGET:-arm-linux-gnueabi}
TARGET=${TARGET:-arm-linux-gnueabihf}
export CROSS_COMPILE=${CROSS_COMPILE:-${TARGET}-}
#export tools=/opt/Xilinx/SDK/2017.2/gnu/arm/lin
#export tools=/opt/Xilinx/SDK/2017.4/gnu/aarch32/lin/gcc-arm-linux-gnueabi
export tools=/usr/local/bin/gcc-linaro-7.2.1-2017.11-i686_arm-linux-gnueabihf
export PATH=${tools}/bin:$PATH
export SYSROOT=$(pwd)/sysroot
export STAGING=$(pwd)/stage

echo Getting plutosdr-fw ${PLUTOSDRFW}
[ -e sysroot-${PLUTOSDRFW}.tar.gz ] || wget https://github.com/analogdevicesinc/plutosdr-fw/releases/download/${PLUTOSDRFW}/sysroot-${PLUTOSDRFW}.tar.gz
echo Setting up sysroot
tar xzf sysroot-${PLUTOSDRFW}.tar.gz
#mv staging ${SYSROOT}
if [ ! -d "${SYSROOT}" ]; then
  mv staging ${SYSROOT}
else
  rm -r ${SYSROOT}
  mv staging ${SYSROOT}
fi
if [ ! -d "${STAGING}" ]; then
  mkdir ${STAGING}
fi

read -rsn1 -p "Press any key to continue..."
echo Building SoapySDR
[ -e SoapySDR ] || git clone https://github.com/pothosware/SoapySDR.git
cd SoapySDR
git checkout soapy-sdr-0.8.1
if [ ! -d "build" ]; then
  mkdir build
fi
cd build ; cmake -DENABLE_PYTHON3=OFF -DENABLE_PYTHON=OFF -DCMAKE_TOOLCHAIN_FILE=../../Toolchain.cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr .. && make install ; cd ..
#rm -r build
cd ..

#read -rsn1 -p "Press any key to continue..."
#echo Building SoapyRemote
#[ -e SoapyRemote ] || git clone https://github.com/pothosware/SoapyRemote.git
#cd SoapyRemote
#mkdir build ; cd build ; cmake -DCMAKE_TOOLCHAIN_FILE=../../Toolchain.cmake -DSoapySDR_DIR=${STAGING}/share/cmake/SoapySDR .. && make && make install ; cd ..
##rm -r build
#cd ..

read -rsn1 -p "Press any key to continue..."
echo Building SoapyPlutoSDR
[ -e SoapyPlutoSDR ] || git clone https://github.com/pothosware/SoapyPlutoSDR.git
cd SoapyPlutoSDR
if [ ! -d "build" ]; then
  mkdir build
fi
cd build ; cmake -DCMAKE_TOOLCHAIN_FILE=../../Toolchain.cmake -DSoapySDR_DIR=${STAGING}/share/cmake/SoapySDR .. && make && make install ; cd ..
#rm -r build
cd ..

read -rsn1 -p "Press any key to continue..."
echo Building rx_tools
[ -e rx_tools ] || git clone https://github.com/rxseger/rx_tools.git
cd rx_tools
if [ ! -d "build" ]; then
  mkdir build
fi
cd build ; cmake -DCMAKE_TOOLCHAIN_FILE=../../Toolchain.cmake -DSoapySDR_DIR=${STAGING}/share/cmake/SoapySDR .. && make && make install ; cd ..
#rm -r build
cd ..

read -rsn1 -p "Press any key to continue..."
echo Building rtl_433
[ -e rtl_433 ] || git clone https://github.com/merbanan/rtl_433
cd rtl_433
if [ ! -d "build" ]; then
  mkdir build
fi
cd build ; cmake -DCMAKEBUILD_TYPE=Release -DENABLE_RTLSDR=OFF -DENABLE_SOAPYSDR=ON -DCMAKE_TOOLCHAIN_FILE=../../Toolchain.cmake -DSoapySDR_DIR=${STAGING}/share/cmake/SoapySDR .. && make && make install ; cd ..
#rm -r build
cd ..

read -rsn1 -p "Press any key to continue..."
echo "Stripping files to reduce size (ignore warnings)"
arm-linux-gnueabihf-strip -sp stage/bin/*
arm-linux-gnueabihf-strip -sp stage/lib/*
arm-linux-gnueabihf-strip -sp stage/lib/SoapySDR/modules0.8/*
echo Packing binaries
cd ${STAGING}
if [ ! -d "usr" ]; then
  mkdir usr
fi
cp -r lib usr
cp -r bin usr
7zr a ../plutosdr-apps.zip bin lib
cd ..
tar cf plutosdr-apps.tar -C ${STAGING} usr
echo "Done"


