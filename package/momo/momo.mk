################################################################################
#
# momo
#
################################################################################

MOMO_VERSION = ceda20f25fb9708c84bc99286b756e8a553b41ce
MOMO_SITE = $(call github,shiguredo,momo,$(MOMO_VERSION))
MOMO_LICENSE = Apache-2.0
MOMO_LICENSE_FILES = LICENSE
MOMO_DEPENDENCIES = host-pkgconf boost cli11 json-for-modern-cpp expat libwebrtc

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
MOMO_CONF_OPTS += -DUSE_LINUX_PULSE_AUDIO=ON
MOMO_DEPENDENCIES += pulseaudio
endif

ifeq ($(BR2_PACKAGE_MOMO_USE_MMAL_ENCODER),y)
MOMO_CONF_OPTS += -DUSE_MMAL_ENCODER=ON
MOMO_DEPENDENCIES += rpi-userland
endif

ifeq ($(BR2_PACKAGE_MOMO_USE_SDL2),y)
MOMO_CONF_OPTS += -DUSE_SDL2=ON
MOMO_DEPENDENCIES += sdl2
else
MOMO_CONF_OPTS += -DUSE_SDL2=OFF
endif

ifeq ($(BR2_PACKAGE_MOMO_USE_GOOGLE_STUN_SERVER),y)
MOMO_CONF_OPTS += -DUSE_GOOGLE_STUN_SERVER=ON
else
MOMO_CONF_OPTS += -DUSE_GOOGLE_STUN_SERVER=OFF
endif

MOMO_CONF_OPTS += \
	-DTARGET_OS=linux \
	-DTARGET_ARCH=arm \
	-DMOMO_COMMIT=$(MOMO_VERSION) \
	-DWEBRTC_COMMIT=$(LIBWEBRTC_VERSION) \
	-DWebRTC_INCLUDE_DIR=$(STAGING_DIR)/usr/include/libwebrtc \
	-DJSON_ROOT_DIR=$(STAGING_DIR)/usr \
	-DCLI11_ROOT_DIR=$(STAGING_DIR)/usr \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_C_FLAGS="$(TARGET_CFLAGS)" \
	-DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS)" \
	-DCMAKE_FIND_DEBUG_MODE=ON

define MOMO_INSTALL_TARGET_CMDS
	cp -dpf $(@D)/momo $(TARGET_DIR)/usr/bin/
endef


$(eval $(cmake-package))
