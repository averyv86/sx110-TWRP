LOCAL_PATH := $(call my-dir)

# TWRP-specific device configuration
PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)

# Inherit from AOSP product configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

# Inherit virtual A/B OTA configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)

# Device properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.board=x110 \
    ro.board.platform=mt6789

# API level
PRODUCT_SHIPPING_API_LEVEL := 33
