#!/bin/bash

local image_tag
image_tag="$1"

export DOCKER_BUILDKIT=1
# docker build -t ghcr.io/aaqaishtyaq/openvscode-server:"${image_tag}" .
docker buildx build --platform linux/arm64 ghcr.io/aaqaishtyaq/openvscode-server:"${image_tag}" --push .
docker create -it --name vscode ghcr.io/aaqaishtyaq/openvscode-server:"${image_tag}"
docker cp vscode:/app/ .
docker rm -f vscode
