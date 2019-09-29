# Inherit full common Liquid stuff
$(call inherit-product, vendor/liquid/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include liquid LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/liquid/overlay/dictionaries

$(call inherit-product, vendor/liquid/config/telephony.mk)
