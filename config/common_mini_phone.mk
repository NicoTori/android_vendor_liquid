# Inherit mini common liquid stuff
$(call inherit-product, vendor/liquid/config/common_mini.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

$(call inherit-product, vendor/liquid/config/telephony.mk)
