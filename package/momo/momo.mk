################################################################################
#
# momo
#
################################################################################

MOMO_VERSION = da91355579cd2b7557588f54f572476bafca4211
MOMO_SITE = $(call github,shiguredo,momo,$(MOMO_VERSION))
MOMO_LICENSE = Apache-2.0
MOMO_LICENSE_FILES = LICENSE
MOMO_DEPENDENCIES = host-pkgconf boost cli11 json-for-modern-cpp libwebrtc \
	$(if $(BR2_PACKAGE_PULSEAUDIO),pulseaudio)

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
	-DWEBRTC_USE_X11=OFF \
	-DCMAKE_C_FLAGS="$(TARGET_CFLAGS)" \
	-DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) \
	  -I$(STAGING_DIR)/usr/include/webrtc \
	  -I$(STAGING_DIR)/usr/include/nlohmann"

$(eval $(cmake-package))
