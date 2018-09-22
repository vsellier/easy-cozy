#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(dirname $0)"

IMAGE=vsellier/easy-cozy
VERSION=latest

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
		PUSH=true
		;;
	h)
		usage
		exit 1
		;;
	esac
done

IMAGE_NAME="${IMAGE}:${VERSION}"

ARM_IMAGE_NAME="${IMAGE}:${VERSION}-arm"
AMD64_IMAGE_NAME="${IMAGE}:${VERSION}-amd64"

if [ -n  "${VERSION_SUFFIX:-}" ]; then
	IMAGE_NAME="${IMAGE_NAME}_${VERSION_SUFFIX}"
	ARM_IMAGE_NAME="${ARM_IMAGE_NAME}_${VERSION_SUFFIX}"
	AMD64_IMAGE_NAME="${AMD64_IMAGE_NAME}_${VERSION_SUFFIX}"
fi

echo "Creating manifest for image ${IMAGE_NAME} composed by ${AMD64_IMAGE_NAME} and ${ARM_IMAGE_NAME}"
echo "Press enter to continue ..."
read

echo "Pull latest images"
docker pull ${AMD64_IMAGE_NAME}
docker pull ${ARM_IMAGE_NAME}

echo "Creation in progress ..."
docker manifest create --amend ${IMAGE_NAME} ${AMD64_IMAGE_NAME} ${ARM_IMAGE_NAME}
if [ $? -ne 0 ]; then
	echo "Error during manifest creation the manifest"
	exit 1
fi

echo "Manifest for ${IMAGE_NAME} created :"
echo "--------------------------------------"
docker manifest inspect ${IMAGE_NAME}
echo "--------------------------------------"

echo "Press enter to continue ..."
read

echo "Pushing the manifest ..."
docker manifest push ${IMAGE_NAME}
if [ $? -ne 0 ]; then
	echo "Error pushing the manifest"
	exit 1
fi

