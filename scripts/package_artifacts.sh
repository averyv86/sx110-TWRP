#!/bin/bash

# Variables
DEVICE_NAME="your_device_name"  # Set your device name
BUILD_TARGET="recovery"          # Set the build target to recovery
OUT_DIR="workspace/out/target/product/${DEVICE_NAME}"

# Collect the recovery image
if [ -f "${OUT_DIR}/${BUILD_TARGET}.img" ]; then
    cp "${OUT_DIR}/${BUILD_TARGET}.img" .
fi

if [ -f "${OUT_DIR}/${BUILD_TARGET}.img.lz4" ]; then
    cp "${OUT_DIR}/${BUILD_TARGET}.img.lz4" recovery.img
else
    cp "${OUT_DIR}/${BUILD_TARGET}.img" recovery.img
fi

# Collect flashable zips
if [ -d "${OUT_DIR}" ]; then
    cp "${OUT_DIR}/*.zip" .
fi

if [ -d "workspace/out/dist" ]; then
    cp "workspace/out/dist/*.zip" .
fi

# Create tar.md5 containing recovery.img
tar --format=gnu -cf recovery.tar .
md5sum recovery.tar > recovery.md5

exit 0
