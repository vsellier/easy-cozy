#!/usr/bin/env bash

set -u

function usage() {
	echo "Install official applications"
	echo
	echo "Usage: $0 <instance> <application>"
	echo "Non exhaustive list of official possible applications :"
	echo "  - drive (installed by default)"
	echo "  - photos (installed by default)"
	echo "  - settings (installed by default)"
	echo "  - banks"
	echo "  - contacts"
	exit 1
}

if [ $# -eq 0 ]; then
	usage
fi

if [ ! -e ".env" ]; then
	echo "Environnement configuration not found (.env file)"
	exit 1
fi

source .env

INSTANCE_ID=$1
APP=$2

INSTANCE="${INSTANCE_ID}.${COZY_TLD}"
echo "Installing $APP application on $INSTANCE"

if [ "$APP" == "banks" ]; then
	BRANCH="latest"
else
	BRANCH="build"
fi

BASE_URL="git://github.com/cozy/cozy-"

APP_URL="${BASE_URL}${APP}.git#${BRANCH}"

echo "Installing from ${APP_URL}"

# TODO allow different actions
docker-compose exec cozy ./cozy apps install --domain ${INSTANCE} ${APP} ${APP_URL}
