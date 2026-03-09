# TWRP Device Tree — Samsung SM-X110 (Galaxy Tab A9 Wi-Fi)

## Device information

| Field        | Value                  |
|--------------|------------------------|
| Model        | Samsung SM-X110        |
| Codename     | x110                   |
| Chipset      | MediaTek Helio G99 (MT6789) |
| Architecture | arm64 / armv8-2a       |
| Android      | 13 (API 33)            |

---

## Status

This is a **scaffold device tree**. Most build-system plumbing is in place
(`AndroidProducts.mk`, `BoardConfig.mk`, `device.mk`, `twrp_x110.mk`), but
**hardware-specific prebuilt binaries must be extracted from the stock firmware
before a recovery image can actually be flashed**.

### Required prebuilt files

The following files must be placed under `device/samsung/x110/prebuilt/`
before a successful build:

| File              | How to obtain                                              |
|-------------------|------------------------------------------------------------|
| `kernel`          | Extract from stock `boot.img` with `unpack_bootimg`        |
| `dtb.img`         | Extract from stock `boot.img` with `unpack_bootimg`        |
| `dtbo.img`        | Extract from the `dtbo` partition via `adb pull` or Odin   |

### Board parameter placeholders

Verify the following values in `BoardConfig.mk` against the actual stock
boot image (use `abootimg -i boot.img` or `unpack_bootimg --boot_img boot.img`):

- `BOARD_KERNEL_BASE`
- `BOARD_KERNEL_PAGESIZE`
- `BOARD_RAMDISK_OFFSET`
- `BOARD_KERNEL_TAGS_OFFSET`
- `BOARD_DTB_OFFSET`
- `BOARD_BOOT_HEADER_VERSION`
- `BOARD_BOOTIMAGE_PARTITION_SIZE`
- `BOARD_RECOVERYIMAGE_PARTITION_SIZE`
- `BOARD_SUPER_PARTITION_SIZE`

---

## Building with GitHub Actions

Trigger the **Recovery Build** workflow (`Actions → Recovery Build → Run workflow`)
using the following inputs (these match the workflow defaults):

| Input              | Value                                                         |
|--------------------|---------------------------------------------------------------|
| `MANIFEST_URL`     | `https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp` |
| `MANIFEST_BRANCH`  | `twrp-12.1`                                                   |
| `DEVICE_TREE_URL`  | `https://github.com/averyv86/sx110-TWRP` (this repo)         |
| `DEVICE_TREE_BRANCH` | `main`                                                      |
| `DEVICE_PATH`      | `device/samsung/x110`                                         |
| `DEVICE_NAME`      | `x110`                                                        |
| `MAKEFILE_NAME`    | `twrp_x110`                                                   |
| `BUILD_TARGET`     | `recovery`                                                    |

> **Note:** When `DEVICE_PATH` (`device/samsung/x110`) exists in the checked-out
> repository, the workflow automatically uses the local tree instead of cloning
> from `DEVICE_TREE_URL`. This means you do **not** need to host the device tree
> in a separate repository.

---

## Local build (manual)

```bash
# 1. Init and sync the TWRP source
repo init -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp -b twrp-12.1 --depth=1
repo sync -j$(nproc) --force-sync

# 2. Place this device tree
mkdir -p device/samsung/x110
cp -r <path-to-this-tree>/. device/samsung/x110/

# 3. Place prebuilt kernel/dtb/dtbo (see above)

# 4. Build
source build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
lunch twrp_x110-eng
make recoveryimage -j$(nproc)
```
