# Inherit common Liquid stuff
$(call inherit-product, vendor/liquid/config/common.mk)

PRODUCT_SIZE := full

# Recorder
PRODUCT_PACKAGES += \
    Recorder
