#!/bin/bash

set -ex

VERSION=$1
DEB_FILE=protonmail-bridge_${VERSION}_amd64.deb
DEB_FILE_NEW=protonmail-bridge_${VERSION}.deb

# Build time dependencies
apt-get install -y wget binutils xz-utils

# Repack deb (remove unnecessary dependencies and replace binary)
mkdir deb
cd deb
wget -q -O ${DEB_FILE} https://github.com/ProtonMail/proton-bridge/releases/download/v3.0.21/protonmail-bridge_3.0.21-1_amd64.deb
ar x -v ${DEB_FILE}

mkdir control
tar zxvf control.tar.gz -C control
sed -i "s/^Depends: .*$/Depends: libgl1, libc6, libsecret-1-0, libstdc++6, libgcc1/" control/control
cd control
tar zcvf ../control.tar.gz .
cd ../

mkdir data
tar zxvf data.tar.gz -C data
mv ../bridge data/usr/lib/protonmail/bridge/proton-bridge
cd data
tar zcvf ../data.tar.gz .
cd ../

ar rcs -v ${DEB_FILE_NEW} debian-binary control.tar.gz data.tar.gz
cd ../
