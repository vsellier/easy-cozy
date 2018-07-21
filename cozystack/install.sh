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
else
	echo "Unknown arch $ARCH"
	exit 1
fi

echo "Install cozy-stack..."

wget -O /tmp/cozy https://github.com/cozy/cozy-stack/releases/download/${COZY_VERSION}/cozy-stack-linux-${COZY_ARCH}
wget -O /tmp/cozy.sha256 https://github.com/cozy/cozy-stack/releases/download/${COZY_VERSION}/cozy-stack-linux-${COZY_ARCH}.sha256

cat <<EOF >/tmp/SHA256
SHA256(/tmp/cozy)= $(awk '{print $2}' cozy.sha256)
EOF

echo "Expected checkum                : $(cat /tmp/SHA256)"
echo "Checksum of the downloaded file : $(sha256sum --tag /tmp/cozy)"
sha256sum -c /tmp/SHA256

chmod u+x /tmp/cozy

echo "Install nodejs..."

wget -O /tmp/node.tar.xz https://nodejs.org/dist/v8.11.3/node-v${NODE_VERSION}-linux-${NODE_ARCH}.tar.xz
tar -xv --use-compress-program xz -f node.tar.xz
mv node-v${NODE_VERSION}-linux-${NODE_ARCH} node
