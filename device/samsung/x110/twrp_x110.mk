
# Inherit from TWRP AOSP base
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit device-specific configuration
$(call inherit-product, $(LOCAL_PATH)/device.mk)

# Product identity
PRODUCT_NAME   := twrp_x110
PRODUCT_DEVICE := x110
PRODUCT_BRAND  := samsung
PRODUCT_MODEL  := SM-X110
PRODUCT_MANUFACTURER := samsung

PRODUCT_GMS_CLIENTID_BASE := android-samsung
