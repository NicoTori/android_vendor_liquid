PRODUCT_VERSION = 10.1
ifneq ($(LIQUID_BUILDTYPE),)
LIQUID_VERSION := -v$(PRODUCT_VERSION)-$(shell date +%Y%m%d)-$(LIQUID_BUILD)-$(LIQUID_BUILDTYPE)
else
LIQUID_VERSION := -v$(PRODUCT_VERSION)-$(shell date +%Y%m%d)-$(LIQUID_BUILD)-Unofficial
endif

# Liquid System Version
    ro.liquid.version=$(LIQUID_VERSION) \
    ro.liquid.releasetype=$(LIQUID_BUILDTYPE) \
    ro.liquid.build.version=$(PRODUCT_VERSION) \
    ro.modversion=$(LIQUID_VERSION) \

