# Versioning System
LIQUID_BASE_VERSION = 10.1

ifndef LIQUID_BUILD_TYPE
    LIQUID_BUILD_TYPE := UNOFFICIAL
endif

# Only include LIQUID-Updater for official, weeklies, and rc builds
ifeq ($(filter-out OFFICIAL WEEKLIES RC,$(LIQUID_BUILD_TYPE)),)
    PRODUCT_PACKAGES += \
        liquid-Updater
endif

# Sign builds if building an official or weekly build
ifeq ($(filter-out OFFICIAL WEEKLIES,$(LIQUID_BUILD_TYPE)),)
    PRODUCT_DEFAULT_DEV_CERTIFICATE := $(KEYS_LOCATION)
endif

# Set all versions
BUILD_DATE := $(shell date -u +%Y%m%d)
BUILD_TIME := $(shell date -u +%H%M)
LIQUID_VERSION := $(TARGET_PROLIQUIDCT)-$(LIQUID_BASE_VERSION)-$(BUILD_DATE)-$(BUILD_TIME)-$(LIQUID_BUILD_TYPE)
TARGET_BACON_NAME := $(LIQUID_VERSION)
ROM_FINGERPRINT := LiquidRemix/$(PLATFORM_VERSION)/$(LIQUID_BUILD_TYPE)/$(BUILD_DATE)$(BUILD_TIME)

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    ro.liquid.version=$(LIQUID_VERSION) \
    ro.mod.version=$(LIQUID_BUILD_TYPE)-$(LIQUID_BASE_VERSION)-$(BUILD_DATE) \
    ro.liquid.fingerprint=$(ROM_FINGERPRINT)
