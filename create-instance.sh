#!/usr/bin/env bash

if [ $# -ne 1 ]; then
	echo "Usage: $0 <instance url>"
	exit 1
fi
INSTANCE_ID=$1

source .env

TMPFILE=$(mktemp /tmp/cozyXXX)

echo "Creating instance ${INSTANCE_ID}.${COZY_TLD} ..."

docker-compose exec cozy ./cozy instances add --host 0.0.0.0 --apps registry,drive,collect,settings,onboarding "${INSTANCE_ID}.${COZY_TLD}" | tee "${TMPFILE}"

## To replace by registry://store/something after next cozy-stack release
docker-compose exec cozy ./cozy apps install --domain "${INSTANCE_ID}.${COZY_TLD}" store registry://store/stable | tee -a "${TMPFILE}"

# TODO find a better way to detect if there was an error
TOKEN=""
if [ $(grep -ic ERROR ${TMPFILE}) -eq 0 ]; then
	TOKEN=$(grep token "${TMPFILE}" | cut -f2 -d":" | tr -d '" ')
fi

rm "${TMPFILE}"

if [ -z "${TOKEN}" ]; then
	echo No token found.
	exit 1
fi

echo "Open this url on a browser to configure your instance https://$INSTANCE_ID.${COZY_TLD}?registerToken=${TOKEN}"
