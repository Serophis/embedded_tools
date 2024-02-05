#!/bin/bash

# Check if all required environment variables are set

if [[ -z "$CROSS_TOOLS_INSTALLATION_PATH" ]]; then
    echo "CROSS_TOOLS_INSTALLATION_PATH is not set"
    exit 1
fi

if [[ -z "$ROOTFS_DIR" ]]; then
    echo "ROOTFS_DIR is not set"
    exit 1
fi

if [[ -z "$TARGET_LOGIN" ]]; then
    echo "TARGET_LOGIN is not set"
    exit 1
fi

if [[ -z "$TARGET_ADDRESS" ]]; then
    echo "TARGET_ADDRESS is not set"
    exit 1
fi

# Install cross tools for Raspberry Pi Zero W (armv6)
cd $CROSS_TOOLS_INSTALLATION_PATH
wget -O- https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-armv6-rpi-linux-gnueabihf.tar.xz | tar xJ

# Synchronize the root file system (this may take half an hour)
mkdir $ROOTFS_DIR
rsync -rl --delete-after --safe-links --copy-unsafe-links $TARGET_LOGIN@$TARGET_ADDRESS:/lib $ROOTFS_DIR/ # Don't use {lib, usr} syntax because it doesn't work
rsync -rl --delete-after --safe-links --copy-unsafe-links $TARGET_LOGIN@$TARGET_ADDRESS:/usr $ROOTFS_DIR/

# Connect to target once to add it to known hosts
ssh $TARGET_LOGIN@$TARGET_ADDRESS