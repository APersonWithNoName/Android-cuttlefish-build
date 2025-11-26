#!/bin/bash

DOCKER_NAME=cuttlefish
REPO_URL=https://github.com/google/android-cuttlefish.git
REPO_NAME=android-cuttlefish

echo "Entering host build environment."

# 克隆储存库
if test -d $REPO_NAME;then
    echo "--- Removing dir $REPO_NAME"
    rm -rf $REPO_NAME
fi
echo "--- Cloning repo from $REPO_URL to $REPO_NAME"
git clone $REPO_URL $REPO_NAME --depth 1

# 生成 bazel缓存目录
echo "--- Making dir bazel-cache"
mkdir -p bazel-cache
echo "--- Making dir output"
mkdir -p output
echo "--- Making dir dist"

echo "--- Building docker container."
docker build -t $DOCKER_NAME $PWD

echo "--- Running docker."
echo "----- Mounting host:$PWD/$REPO_NAME to $DOCKER_NAME:/workspace/src/$REPO_NAME"
echo "----- Mounting host:$PWD/bazel-cache to $DOCKER_NAME:/root/.cache/bazel"
docker run -rm \
    -v $PWD/$REPO_NAME:/workspace/src \
    -v $PWD/bazel-cache:/root/.cache/bazel \
    -v $PWD/output:/workspace/output \
    -v $PWD/dist:/workspace/dist \
    -e REPO_NAME=$REPO_NAME \
    -e TARBALL_NAME=android-cuttlefish-aarch64-debian-build_$(date +%Y%m%d).tar.gz \
    $DOCKER_NAME

echo "Docker environment exit, entering host."

echo "--- Cpoying tarball to host."
