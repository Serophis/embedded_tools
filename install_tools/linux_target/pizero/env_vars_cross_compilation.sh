#!/bin/bash

# Description : This file is used to load environment variables for cross-compilation
# Usage: source env_vars_cross_compilation.sh 
# Author: Eliot Coulon 
# Warning : it must be sourced in every new terminal (not executed) or sourced in your .bashrc

# Keep or adapt the following variables
export CROSS_TOOLS_INSTALLATION_PATH=~/tools # Path where cross tools will be installed
export ROOTFS_DIR=rootfs_pizero # Name of the directory to install cross tools

# ADAPT the following variables to your needs
export TARGET_LOGIN=user # User on the target
export TARGET_ADDRESS=12.34.56.78 # IP address of the target
export TARGET_PASSWORD="" # Password of the target user
export EXECUTABLE_NAME= # Name of the executable to be deployed on target
export GDB_TARGET_PORT=4444 # Port used by gdbserver on target

# Used in Makefile and by `go build`
export CROSS_TRIPLET_PREFIX=$CROSS_TOOLS_INSTALLATION_PATH/x-tools/armv6-rpi-linux-gnueabihf/bin/armv6-rpi-linux-gnueabihf- # Cross compiler path
export CROSS_GCC=${CROSS_TRIPLET_PREFIX}gcc # Cross compiler path
export CROSS_AR=${CROSS_TRIPLET_PREFIX}ar # Cross ar path
export CROSS_SYSROOT=$CROSS_TOOLS_INSTALLATION_PATH/$ROOTFS_DIR/ # Cross sysroot path
export CPATH=$CROSS_SYSROOT # USED BY CGO ONLY - Add sysroot to CPATH so CGO can find headers and build correctly