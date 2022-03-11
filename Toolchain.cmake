# Linux, Windows, or Darwin
SET(CMAKE_SYSTEM_NAME Linux)
# not really needed
SET(CMAKE_SYSTEM_PROCESSOR arm)
SET(CMAKE_SYSTEM_VERSION 1)
# Set to plutosdr-fw sysroot dir
SET(CMAKE_SYSROOT $ENV{SYSROOT})
# Set to output dir
SET(CMAKE_STAGING_PREFIX $ENV{STAGING})
# Set for SoapySDR to locate it's module search path (/usr/lib/SoapySDR/modules0.7)
SET(CMAKE_INSTALL_PREFIX:PATH /usr)

# specify the base directory for the cross compiler
IF(DEFINED ENV{tools})
    SET(tools $ENV{tools})
ELSE()
    SET(tools /usr)
ENDIF()

# specify the cross compiler prefix
IF(DEFINED ENV{CROSS_COMPILE})
    SET(cross_compile $ENV{CROSS_COMPILE})
ELSE()
    SET(cross_compile arm-linux-gnueabi-)
ENDIF()

# where is the target environment, choose gnueabi/gnueabihf and GCC major
#SET(CMAKE_FIND_ROOT_PATH ${tools}/lib/gcc-cross/arm-linux-gnueabi/5)
#SET(CMAKE_FIND_ROOT_PATH ${tools}/lib/gcc-cross/arm-linux-gnueabi/6)
#SET(CMAKE_FIND_ROOT_PATH ${tools}/lib/gcc/arm-linux-gnueabihf/6.2.1)

#SET(CMAKE_C_COMPILER ${tools}/bin/arm-xilinx-linux-gnueabi-gcc)
#SET(CMAKE_C_COMPILER ${tools}/bin/arm-linux-gnueabi-gcc)
#SET(CMAKE_C_COMPILER ${tools}/bin/arm-linux-gnueabihf-gcc)
SET(CMAKE_C_COMPILER ${tools}/bin/${cross_compile}gcc)

#SET(CMAKE_CXX_COMPILER ${tools}/bin/arm-xilinx-linux-gnueabi-g++)
#SET(CMAKE_CXX_COMPILER ${tools}/bin/arm-linux-gnueabi-g++)
#SET(CMAKE_CXX_COMPILER ${tools}/bin/arm-linux-gnueabihf-g++)
SET(CMAKE_CXX_COMPILER ${tools}/bin/${cross_compile}g++)

SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
# Set for Soapy modules and rtl_433 to locate staged SoapySDR libs
SET(CMAKE_PREFIX_PATH ${CMAKE_STAGING_PREFIX})
