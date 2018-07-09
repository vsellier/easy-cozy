#!/usr/bin/env bash

# set -x
set -eu

SCRIPT_DIR="$(dirname $0)"

IMAGE=vsellier/easy-cozy
VERSION=latest
PUSH=false

function usage() {
	echo "$0 [-v <version>] [-p] [-h]"
	echo "-v <version>  : Specify the version to build default: latest"
	echo "-p            : Push the image to docker hub"
	echo "-h            : display this help"
}

while getopts "v:ph" opt; do
	case $opt in
	v)
		VERSION=${OPTARG}
		;;
	p)
		PUSH=true
		;;
	h)
		usage
		exit 1
		;;
	esac
done

LOCAL_ARCH="$(uname -m)"
IMAGE_ARCH="amd64"

if [[ "${LOCAL_ARCH}" =~ "arm" ]]; then
	IMAGE_ARCH="arm"
fi

COMPLETE_IMAGE_NAME="${IMAGE}:${VERSION}-${IMAGE_ARCH}"

pushd "${SCRIPT_DIR}/../cozystack" || exit

echo "Refreshing base image..."
docker pull debian:stable-slim

echo "Building ${COMPLETE_IMAGE_NAME}"
docker build --no-cache -t ${COMPLETE_IMAGE_NAME} .

if $PUSH; then
	echo "Pushing to Docker Hub"
	docker push ${COMPLETE_IMAGE_NAME}
fi
popd
