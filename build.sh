#!/bin/sh

DOCKER_HUB_PROJECT=snowdreamtech/transmission

GITHUB_PROJECT=ghcr.io/snowdreamtech/transmission

docker buildx build --platform=linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/ppc64le,linux/riscv64,linux/s390x \
-t ${DOCKER_HUB_PROJECT}:latest \
-t ${DOCKER_HUB_PROJECT}:4.0.5 \
-t ${DOCKER_HUB_PROJECT}:4.0 \
-t ${DOCKER_HUB_PROJECT}:4 \
-t ${GITHUB_PROJECT}:latest \
-t ${GITHUB_PROJECT}:4.0.5 \
-t ${GITHUB_PROJECT}:4.0 \
-t ${GITHUB_PROJECT}:4 \
. \
--push
