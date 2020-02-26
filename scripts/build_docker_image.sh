#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE="docker-example"
TAG="v1"

helm del --purge ${MODULE}
sleep 5s
docker image rm "${MODULE}:${TAG}"
docker run --rm -i hadolint/hadolint < Dockerfile
docker build --pull -t "${MODULE}:${TAG}" .
helm upgrade --install ${MODULE} --namespace default ${MODULE}