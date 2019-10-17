# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

PRODUCT_BRAND ?= NicoTori

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# Default notification/alarm sounds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Hassium.ogg

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.dun.override=0
endif

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/liquid/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/liquid/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/liquid/prebuilt/common/bin/50-liquid.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-liquid.sh \
    vendor/liquid/prebuilt/common/bin/blacklist:$(TARGET_COPY_OUT_SYSTEM)/addon.d/blacklist

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/liquid/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/liquid/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/liquid/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh
endif

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/liquid/config/permissions/backup.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/backup.xml

# liquid-specific broadcast actions whitelist
PRODUCT_COPY_FILES += \
    vendor/liquid/config/permissions/liquid-sysconfig.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/liquid-sysconfig.xml

# init.d support
PRODUCT_COPY_FILES += \
    vendor/liquid/prebuilt/common/etc/init.d/00banner:$(TARGET_COPY_OUT_SYSTEM)/etc/init.d/00banner \
    vendor/liquid/prebuilt/common/bin/sysinit:$(TARGET_COPY_OUT_SYSTEM)/bin/sysinit

ifneq ($(TARGET_BUILD_VARIANT),user)
# userinit support
PRODUCT_COPY_FILES += \
    vendor/liquid/prebuilt/common/etc/init.d/90userinit:$(TARGET_COPY_OUT_SYSTEM)/etc/init.d/90userinit
endif

# Copy all liquid-specific init rc files
$(foreach f,$(wildcard vendor/liquid/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/liquid/prebuilt/common/lib/content-types.properties:$(TARGET_COPY_OUT_SYSTEM)/lib/content-types.properties

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/Vendor_045e_Product_0719.kl

# This is LIQUID!
PRODUCT_COPY_FILES += \
    vendor/liquid/config/permissions/org.liquid.android.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/org.liquid.android.xml \
    vendor/liquid/config/permissions/privapp-permissions-liquid-system.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-liquid.xml \
    vendor/liquid/config/permissions/privapp-permissions-liquid-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-liquid.xml \
    vendor/liquid/config/permissions/privapp-permissions-cm-legacy.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-cm-legacy.xml

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

# Hidden API whitelist
PRODUCT_COPY_FILES += \
    vendor/liquid/config/permissions/liquid-hiddenapi-package-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/liquid-hiddenapi-package-whitelist.xml

# Power whitelist
PRODUCT_COPY_FILES += \
    vendor/liquid/config/permissions/liquid-power-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/liquid-power-whitelist.xml

# Include AOSP audio files
include vendor/liquid/config/aosp_audio.mk

# TWRP
ifeq ($(WITH_TWRP),true)
include vendor/liquid/config/twrp.mk
endif

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Include LiquidRemix boot animation
PRODUCT_COPY_FILES += \
    vendor/liquid/prebuilt/common/media/bootanimation.zip:system/media/bootanimation.zip

# AOSP packages
PRODUCT_PACKAGES += \
    ExactCalculator \
    Exchange2 \
    Terminal

# Extra tools in liquid
PRODUCT_PACKAGES += \
    7z \
    awk \
    bash \
    bzip2 \
    curl \
    getcap \
    htop \
    lib7z \
    libsepol \
    pigz \
    powertop \
    setcap \
    unrar \
    unzip \
    vim \
    wget \
    zip

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

# Custom off-mode charger
ifeq ($(WITH_LIQUID_CHARGER),true)
PRODUCT_PACKAGES += \
    liquid_charger_res_images \
    font_log.png \
    libhealthd.liquid
endif

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    fsck.ntfs \
    mke2fs \
    mkfs.exfat \
    mkfs.ntfs \
    mount.ntfs

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    micro_bench \
    procmem \
    procrank \
    strace

# Conditionally build in su
ifneq ($(TARGET_BUILD_VARIANT),user)
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su
endif
endif

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/liquid/overlay
DEVICE_PACKAGE_OVERLAYS += vendor/liquid/overlay/common

PRODUCT_VERSION_MAJOR = 10
PRODUCT_VERSION_MINOR = 1
PRODUCT_VERSION_MAINTENANCE :=

ifeq ($(TARGET_VENDOR_SHOW_MAINTENANCE_VERSION),true)
    LIQUID_VERSION_MAINTENANCE := $(PRODUCT_VERSION_MAINTENANCE)
else
    LIQUID_VERSION_MAINTENANCE := 0
endif

# Set LIQUID_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

ifndef LIQUID_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "LIQUID_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^LIQUID_||g')
        LIQUID_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Filter out random types, so it'll reset to UNOFFICIAL
ifeq ($(filter RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL,$(LIQUID_BUILDTYPE)),)
    LIQUID_BUILDTYPE :=
endif

ifdef LIQUID_BUILDTYPE
    ifneq ($(LIQUID_BUILDTYPE), SNAPSHOT)
        ifdef LIQUID_EXTRAVERSION
            # Force build type to EXPERIMENTAL
            LIQUID_BUILDTYPE := EXPERIMENTAL
            # Remove leading dash from LIQUID_EXTRAVERSION
            LIQUID_EXTRAVERSION := $(shell echo $(LIQUID_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to LIQUID_EXTRAVERSION
            LIQUID_EXTRAVERSION := -$(LIQUID_EXTRAVERSION)
        endif
    else
        ifndef LIQUID_EXTRAVERSION
            # Force build type to EXPERIMENTAL, SNAPSHOT mandates a tag
            LIQUID_BUILDTYPE := EXPERIMENTAL
        else
            # Remove leading dash from LIQUID_EXTRAVERSION
            LIQUID_EXTRAVERSION := $(shell echo $(LIQUID_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to LIQUID_EXTRAVERSION
            LIQUID_EXTRAVERSION := -$(LIQUID_EXTRAVERSION)
        endif
    endif
else
    # If LIQUID_BUILDTYPE is not defined, set to UNOFFICIAL
    LIQUID_BUILDTYPE := UNOFFICIAL
    LIQUID_EXTRAVERSION :=
endif

ifeq ($(LIQUID_BUILDTYPE), UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        LIQUID_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

ifeq ($(LIQUID_BUILDTYPE), RELEASE)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
        LIQUID_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(LIQUID_BUILD)
    else
        ifeq ($(TARGET_BUILD_VARIANT),user)
            ifeq ($(LIQUID_VERSION_MAINTENANCE),0)
                LIQUID_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(LIQUID_BUILD)
            else
                LIQUID_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(LIQUID_VERSION_MAINTENANCE)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(LIQUID_BUILD)
            endif
        else
            LIQUID_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(LIQUID_BUILD)
        endif
    endif
else
    ifeq ($(LIQUID_VERSION_MAINTENANCE),0)
        ifeq ($(LIQUID_VERSION_APPEND_TIME_OF_DAY),true)
            LIQUID_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d_%H%M%S)-$(LIQUID_BUILDTYPE)$(LIQUID_EXTRAVERSION)-$(LIQUID_BUILD)
        else
            LIQUID_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d)-$(LIQUID_BUILDTYPE)$(LIQUID_EXTRAVERSION)-$(LIQUID_BUILD)
        endif
    else
        ifeq ($(LIQUID_VERSION_APPEND_TIME_OF_DAY),true)
            LIQUID_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(LIQUID_VERSION_MAINTENANCE)-$(shell date -u +%Y%m%d_%H%M%S)-$(LIQUID_BUILDTYPE)$(LIQUID_EXTRAVERSION)-$(LIQUID_BUILD)
        else
            LIQUID_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(LIQUID_VERSION_MAINTENANCE)-$(shell date -u +%Y%m%d)-$(LIQUID_BUILDTYPE)$(LIQUID_EXTRAVERSION)-$(LIQUID_BUILD)
        endif
    endif
endif

PRODUCT_EXTRA_RECOVERY_KEYS += \
    vendor/liquid/build/target/security/liquid

-include vendor/liquid-priv/keys/keys.mk

LIQUID_DISPLAY_VERSION := $(LIQUID_VERSION)

ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),)
ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),build/target/product/security/testkey)
    ifneq ($(LIQUID_BUILDTYPE), UNOFFICIAL)
        ifndef TARGET_VENDOR_RELEASE_BUILD_ID
            ifneq ($(LIQUID_EXTRAVERSION),)
                # Remove leading dash from LIQUID_EXTRAVERSION
                LIQUID_EXTRAVERSION := $(shell echo $(LIQUID_EXTRAVERSION) | sed 's/-//')
                TARGET_VENDOR_RELEASE_BUILD_ID := $(LIQUID_EXTRAVERSION)
            else
                TARGET_VENDOR_RELEASE_BUILD_ID := $(shell date -u +%Y%m%d)
            endif
        else
            TARGET_VENDOR_RELEASE_BUILD_ID := $(TARGET_VENDOR_RELEASE_BUILD_ID)
        endif
        ifeq ($(LIQUID_VERSION_MAINTENANCE),0)
            LIQUID_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(LIQUID_BUILD)
        else
            LIQUID_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(LIQUID_VERSION_MAINTENANCE)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(LIQUID_BUILD)
        endif
    endif
endif
endif

-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/liquid/config/partner_gms.mk
