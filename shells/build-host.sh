#!/bin/bash

DOCKER_NAME=cuttlefish
DOCKER_LABEL=latest
REPO_URL=https://github.com/google/android-cuttlefish.git
REPO_NAME=android-cuttlefish

echo "Entering host build environment."

# 克隆储存库
echo "--- Cloning repo from $REPO_URL to $REPO_NAME"
git clone $REPO_URL $REPO_NAME --depth 1

# 生成 bazel缓存目录
echo "--- Making dir bazel-cache"
mkdir -p bazel-cache
echo "--- Making dir debs"
mkdir -p debs
echo "--- Making dir tarball"
mkdir -p tarball

echo "--- Building docker container."
cp ./Dockerfile.aarch64.debian Dockerfile
docker build -t $DOCKER_NAME:$DOCKER_LABEL "$PWD"

echo "--- Running docker."
echo "----- Mounting host:$PWD/$REPO_NAME to $DOCKER_NAME:/workspace/src/$REPO_NAME"
echo "----- Mounting host:$PWD/bazel-cache to $DOCKER_NAME:/root/.cache/bazel"
docker run --rm \
    -v "$PWD/$REPO_NAME:/workspace/src/$REPO_NAME" \
    -v "$PWD/bazel-cache:/root/.cache/bazel" \
    -v "$PWD/$REPO_NAME:/workspace/src/$REPO_NAME" \
    -v "$PWD/debs:/workspace/debs" \
    -v "$PWD/tarball:/workspace/tarball" \
    -e "REPO_NAME=$REPO_NAME" \
    -e "TARBALL_NAME=android-cuttlefish-aarch64-debian-build_$(date +%Y%m%d).tar.gz" \
    $DOCKER_NAME:$DOCKER_LABEL

echo "Docker environment exit, entering host."
