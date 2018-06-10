#!/bin/bash

ARCH=$(uname -m)
COZY_ARCH=""

if [[ $ARCH =~ "x86" ]]; then
	COZY_ARCH=amd64
elif [[ $ARCH =~ "arm" ]]; then
	COZY_ARCH=arm
else
	echo "Unknown arch $ARCH"
	exit 1
fi

wget -O /tmp/cozy https://github.com/cozy/cozy-stack/releases/download/${COZY_VERSION}/cozy-stack-linux-${COZY_ARCH}-${COZY_VERSION}
chmod u+x /tmp/cozy
