#!/bin/bash
#
# Push all local repositories to a local registry
#
# Usage: ./push.sh docker-registry.example.com:5000

REGISTRY="${1}"

if [[ -z "${REGISTRY}" ]]
then
	echo "usage: ${0} REGISTRY" >&2
	exit 1
fi

DOCKER_IO=$(command -v docker.io)
DOCKER="${DOCKER:-${DOCKER_IO:-docker}}"

while read REPOSITORY TAG HASH OTHER
do
	case "${REPOSITORY}" in
	*none*|REPOSITORY)
		continue  # not named or header line
		;;
	"${REGISTRY}"/*)
		continue  # already registered
		;;
	esac
	echo "${DOCKER}" tag -f "${HASH}" "${REGISTRY}/${REPOSITORY}:${TAG}" &&
	"${DOCKER}" tag -f "${HASH}" "${REGISTRY}/${REPOSITORY}:${TAG}" &&
	echo "${DOCKER}" push "${REGISTRY}/${REPOSITORY}"
	"${DOCKER}" push "${REGISTRY}/${REPOSITORY}"
done < <("${DOCKER}" images)
