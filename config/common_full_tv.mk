# Exclude AudioFX
TARGET_EXCLUDES_AUDIOFX := true

# Inherit full common liquid stuff
$(call inherit-product, vendor/liquid/config/common_full.mk)

# Inherit liquid atv device tree
$(call inherit-product, device/liquid/atv/liquid_atv.mk)

PRODUCT_PACKAGES += \
    AppDrawer \
    liquidCustomizer

DEVICE_PACKAGE_OVERLAYS += vendor/liquid/overlay/tv
