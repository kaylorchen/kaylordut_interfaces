#!/bin/bash
apt-get update
apt-get install -y debhelper devscripts fakeroot
set -xe
source /opt/ros/humble/setup.bash
rosdep update
export EMAIL=kaylor.chen@qq.com
SOURCE_ROOT=$(pwd)
mkdir ${SOURCE_ROOT}/artifacts 
git config --global --add safe.directory ${SOURCE_ROOT}
VERSION=$(git describe --tags --long).$(git branch --show-current).$(TZ="Asia/Shanghai" date +"%Y%m%d.%H%M%S")
VERSION=$(echo ${VERSION} | tr _ -)
echo "Version is $VERSION"
dch -b -v ${VERSION} $(git log -n 1 --pretty=format:"%s")
DEB_BUILD_OPTIONS=parallel=15 fakeroot debian/rules binary
mv -v ../*.deb ${SOURCE_ROOT}/artifacts