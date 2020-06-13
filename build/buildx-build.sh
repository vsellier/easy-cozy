#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(dirname $0)"

IMAGE=vsellier/easy-cozy
VERSION=latest
PUSH=false
PLATFORMS="linux/amd64,linux/arm64,linux/arm/v7"
BUILDX_OPTIONS="" 

function usage() {
	echo "$0 [-v <version>] [-p] [-h]"
	echo "-v <version>  : Specify the version to build default: latest"
	echo "-s <suffix>   : Specify a suffix to add to the version name <version>_<suffix>"
	echo "-p            : Push the image to docker hub"
	echo "-h            : display this help"
}

while getopts "v:phs:" opt; do
	case $opt in
	v)
		VERSION=${OPTARG}
		;;
	s)
		VERSION_SUFFIX=${OPTARG}
		;;
	p)
		BUILDX_OPTIONS="${BUILDX_OPTIONS} --push"
		;;
	h)
		usage
		exit 1
		;;
    *)
        echo "unkonw flag ${opt}"
        usage
        exit 1
        ;;
	esac
done

COMPLETE_IMAGE_NAME="${IMAGE}:${VERSION}"
if [ -n  "${VERSION_SUFFIX:-}" ]; then
	COMPLETE_IMAGE_NAME="${COMPLETE_IMAGE_NAME}_${VERSION_SUFFIX}"
fi

pushd "${SCRIPT_DIR}/../cozystack" || exit

echo "Preparing easy-cozy image version ${COMPLETE_IMAGE_NAME}"

echo "Refreshing base image..."
docker pull debian:stable-slim

echo "Building the image for the ${PLATFORMS} platforms"
docker buildx build --platform ${PLATFORMS} -t "${COMPLETE_IMAGE_NAME}" ${BUILDX_OPTIONS} .
