#!/bin/bash -eu

ARCH=$(uname -m)
COZY_ARCH=""
NODE_ARCH=""

if [[ $ARCH =~ "x86" ]]; then
	COZY_ARCH=amd64
	NODE_ARCH=x64
	SHA256="f86c88a99981ed9c64289465d68a97f991af743834981691074688d5d039e6f3"
elif [[ $ARCH =~ "arm" ]]; then
	COZY_ARCH=arm
	NODE_ARCH=armv7l
	SHA256="1c3cc78362471effc7a9fd7f52accac943ab0a009e4d31f4c4d850dffd4d444b"
else
	echo "Unknown arch $ARCH"
	exit 1
fi

echo "Install cozy-stack..."
cat <<EOF >/tmp/SHA256
SHA256(/tmp/cozy)= ${SHA256}
EOF

wget -O /tmp/cozy https://github.com/cozy/cozy-stack/releases/download/${COZY_VERSION}/cozy-stack-linux-${COZY_ARCH}

echo "Expected checkum                : $(cat /tmp/SHA256)"
echo "Checksum of the downloaded file : $(sha256sum --tag /tmp/cozy)"
sha256sum -c /tmp/SHA256

chmod u+x /tmp/cozy

echo "Install nodejs..."

wget -O /tmp/node.tar.xz https://nodejs.org/dist/v8.11.3/node-v${NODE_VERSION}-linux-${NODE_ARCH}.tar.xz
tar -xv --use-compress-program xz -f node.tar.xz
mv node-v${NODE_VERSION}-linux-${NODE_ARCH} node
