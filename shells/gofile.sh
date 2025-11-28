#!/bin/bash

if test -z "$TARBALL_NAME";then
    TARBALL_NAME=android-cuttlefish-aarch64-debian-build_$(date +%Y%m%d).tar.gz
fi
echo "--- Checking ENV REPO_NAME is $TARBALL_NAME"


echo "--- Testing gofile.io"
curl -X POST 'https://store1.gofile.io/contents/uploadfile'  -F "file=@list.lst" | tee /workspace/gofile.status.json
_status=$(jq '.status' /workspace/gofile.status.json )
if [ "_status" == "ok" ];then
    echo "----- Gofile.io is ok."
else
    echo "----- Cannot connect to gofile.io"
    exit 1
fi

echo "--- Upload file /workspace/dist/$TARBALL_NAME"
curl -X POST 'https://store1.gofile.io/contents/uploadfile'  -F "file=@/workspace/dist/$TARBALL_NAME" | tee /workspace/gofile.upload.json
_page=$(jq '.data.downloadPage' /workspace/gofile.upload.json )
_ustatus=$(jq '.status' /workspace/gofile.upload.json )
echo "----- Page is $_page"
echo "----- Status is $_ustatus"

exit 0

