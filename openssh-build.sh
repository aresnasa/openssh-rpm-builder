#!/bin/bash
LXC_IMG_ID=$(docker build --rm .|grep "Successfully built"|awk {'print $NF'})
LXC_NAME="rpm-build"
LXC_PID=$(docker ps|grep $LXC_NAME|awk {"print $1"})
LXC_RPM_DIR="/root/rpmbuild/RPMS"
LOC_RPM_DIR="openssh-upgrade/RPMS"

[ -z "$LXC_CON" ] && { docker rm -f $LXC_NAME; docker run -td --name rpm-build $LXC_IMG_ID bash; }

echo "LXC_IMG_ID: "$LXC_IMG_ID
echo "LXC_NAME: "$LXC_NAME
echo "LXC_RPM_DIR: "$LXC_RPM_DIR
echo "LOC_RPM_DIR: "$LOC_RPM_DIR

[ -d "$LOC_RPM_DIR" ]; rm -rf $LOC_RPM_DIR || echo "copy NEW RPMS to "$LOC_RPM_DIR;docker cp $LXC_NAME:$LXC_RPM_DIR $LOC_RPM_DIR;ls $LOC_RPM_DIR/*
