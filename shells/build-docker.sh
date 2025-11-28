#!/bin/bash

echo "Entering docker environment."

if test -z "$REPO_NAME";then
    REPO_NAME=android-cuttlefish
fi
echo "--- Checking ENV REPO_NAME is $REPO_NAME"

if test -z "$TARBALL_NAME";then
    TARBALL_NAME=android-cuttlefish-aarch64-debian-build_$(date +%Y%m%d).tar.gz
fi
echo "--- Checking ENV REPO_NAME is $TARBALL_NAME"

echo "--- Changing dir to $REPO_NAME"
cd /workspace/src/$REPO_NAME

echo "--- Start building."
for dir in base frontend;do
    echo "----- Entering $dir"
    cd $dir
    echo "----- Building packages."
    debuild -i -us -uc -b -d
    echo "----- Backing."
    cd ..
done
unset dir

echo "--- Cpoying pkgs to /workspace/output"
find . -name "*.deb" -exec cp {} /workspace/output \;

echo "--- Creating tarball $TARBALL_NAME"
tar -cvf /workspace/dist/$TARBALL_NAME /workspace/output/*

/workspace/gofile.sh

exit 0

