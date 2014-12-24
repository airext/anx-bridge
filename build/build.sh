#!/bin/bash

unzip -o anx-bridge.swc

#package ane
adt -package -storetype pkcs12 -keystore $AIR_CERTIFICATE -storepass $AIR_CERTIFICATE_STOREPASS -target ane anx-bridge.ane extension.xml -swc anx-bridge.swc -platform iPhone-ARM library.swf -platformoptions ios-platform.xml -C ios . -platform MacOS-x86 library.swf -C osx .

#copy ANE into bin directory
cp -R anx-bridge.ane ../bin/anx-bridge.ane

#clean
rm library.swf
rm catalog.xml