#!/bin/bash -eu

ARCH=$(uname -m)
COZY_ARCH=""
NODE_ARCH=""

if [[ $ARCH =~ "x86" ]]; then
	COZY_ARCH=amd64
	NODE_ARCH=x64
elif [[ $ARCH =~ "arm" ]]; then
	COZY_ARCH=arm
	NODE_ARCH=armv7l
elif [[ $ARCH =~ "aarch64" ]]; then
	COZY_ARCH=arm
	NODE_ARCH=arm64
else
	echo "Unknown arch $ARCH"
	exit 1
fi

echo "Install cozy-stack..."
# for an obscure reason, in arm/v7, wget didn't recognize the digicert certificate if the ca-certificate path is not specified
wget --ca-certificate=/etc/ssl/certs/ca-certificates.crt -O /tmp/cozy-stack-linux-${COZY_ARCH}-${COZY_VERSION} https://github.com/cozy/cozy-stack/releases/download/${COZY_VERSION}/cozy-stack-linux-${COZY_ARCH}-${COZY_VERSION}
wget --ca-certificate=/etc/ssl/certs/ca-certificates.crt -O /tmp/cozy.sha256 https://github.com/cozy/cozy-stack/releases/download/${COZY_VERSION}/cozy-stack-linux-${COZY_ARCH}-${COZY_VERSION}.sha256

awk "{print \"SHA256(/tmp/cozy-stack-linux-${COZY_ARCH}-${COZY_VERSION})=\",\$2}" /tmp/cozy.sha256 > /tmp/SHA256


echo "Expected checkum                : $(cat /tmp/SHA256)"
echo "Checksum of the downloaded file : $(sha256sum --tag /tmp/cozy-stack-linux-${COZY_ARCH}-${COZY_VERSION})"
sha256sum -c /tmp/SHA256

mv /tmp/cozy-stack-linux-${COZY_ARCH}-${COZY_VERSION} /tmp/cozy
chmod u+x /tmp/cozy

echo "Install nodejs..."

wget --ca-certificate=/etc/ssl/certs/ca-certificates.crt -O /tmp/node.tar.xz https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${NODE_ARCH}.tar.xz
tar -xv --use-compress-program xz -f node.tar.xz
mv node-v${NODE_VERSION}-linux-${NODE_ARCH} node
