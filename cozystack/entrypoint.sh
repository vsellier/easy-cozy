#!/bin/bash

if [ ! -e /etc/cozy/cozy-admin-passphrase ]; then
	./cozy config password /etc/cozy
else
	echo "Admin passphrase already exists, skipping initialization"
fi

./cozy serve
