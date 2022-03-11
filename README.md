# PlutoSDR cross sompiled application
Simple scripts to cross compile common SDR apps to run directly on PlutoSDR

Shamelessly plagiarizing https://github.com/zuckschwerdt/PlutoSDR-Apps, here are a couple of scripts to cross compile common SDR apps to run directly on the PlutoSDR.

# Prerequisites

Linux/Ubuntu machine
Linaro toolchain as per https://wiki.analog.com/university/tools/pluto/devs/embedded_code, environment variables properly set

# Project setup, compile and installation

Once the prerequisites are met, create a work directory, and copy the included files. Make the cross_build.sh script and the file stripping utility arm-linux-gnueabihf-strip executable. Execute cross_build.sh, and everything should work. I added "Press any key to continue" after each major step to help understand what is going on.

Assuming that all the steps are correctly executed, a couple of files are created in the work directory: plutosdr-apps.tar and plutosdr-apps.zip. As of this writing, the .tar file is roughly 1Mbyte in size. Copy the .tar file to the PlutoSDR with:

`scp plutosdr-apps.tar root@192.168.2.1:/tmp` (check that the IP address is the correct one for PlutoSDR, and enter the correct password, usually analog)

then log into PlutoSDR with `ssh root@192.168.2.1` and issue the following commands

```cd /
tar -xvf /tmp/plutosdr-apps.tar
```
The output should look like this

```
usr/
usr/lib/
usr/lib/libSoapySDR.so.0.8.1
usr/lib/pkgconfig/
usr/lib/pkgconfig/SoapySDR.pc
usr/lib/libSoapySDR.so.0.8
usr/lib/SoapySDR/
usr/lib/SoapySDR/modules0.8/
usr/lib/SoapySDR/modules0.8/libPlutoSDRSupport.so
usr/lib/libSoapySDR.so
usr/bin/
usr/bin/SoapySDRUtil
usr/bin/rtl_433
usr/bin/rx_sdr
usr/bin/rx_fm
usr/bin/rx_power
```

At this point rtl_433 or rx_fm can be executed directly on PlutoSDR, for example `rtl_433 -d driver=plutosdr -f 433M -g 20`

# Notes

The script is working without errors as of February 2022, with firmware 0,34w. Changes to the firmware or the upstream projects might break things, but hopefully the script and Toolchain.cmake are easy to follow and modify
The script is not optimized for multiple runs (e.g. downloads sysroot every time), but can be executed multiple times and only changed files are recompiled

# SoapyPlutoSDR notes

SoapyPlutoSDR is written to look for PlutSDR either as local, IP or USB. If compiled unchanged, the code will print an error message due to the lack of USB, and will wait for a timeout on the network search. Having to wait a few seconds every time a program is launched gets old rather quickly. The problem can be easily fixed by editing PlutoSDR_Registration.cpp from

```
	// Backends can error, scan each one individually
	std::vector<std::string> backends = {"local", "usb", "ip"};
  ```
to
```
  // Backends can error, scan each one individually
	std::vector<std::string> backends = {"local"};
  ```
  
 
