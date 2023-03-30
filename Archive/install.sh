#!/bin/bash

set -ex

VERSION=$1
DEB_FILE=protonmail-bridge_${VERSION}.deb

# Install dependents
apt-get update
apt-get install -y --no-install-recommends socat pass ca-certificates

# Install protonmail bridge
apt-get install -y --no-install-recommends ./${DEB_FILE}

# Cleanup
apt-get autoremove -y
rm -rf /var/lib/apt/lists/*
rm -rf deb
