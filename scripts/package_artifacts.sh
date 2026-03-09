#!/bin/bash

DEVICE_NAME=$1
BUILD_TARGET=$2

# Collect output images
mkdir -p workspace/artifacts
cp workspace/out/target/product/$DEVICE_NAME/*.img workspace/artifacts/

# Collect zip files
cp workspace/out/dist/*.zip workspace/artifacts/

# Create Odin tar.md5
OUTPUT_FILES=""
for img in recovery.img boot.img vendor_boot.img; do
  if [ -f workspace/artifacts/$img ]; then
    OUTPUT_FILES+="workspace/artifacts/$img "
  fi
done

# Create tar.md5
if [[ -n "$OUTPUT_FILES" ]]; then
  tar -cvf workspace/artifacts/odin.tar $OUTPUT_FILES
  md5sum workspace/artifacts/odin.tar >> workspace/artifacts/odin.tar.md5
fi
