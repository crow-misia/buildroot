################################################################################
#
# libmediasoupclient
#
################################################################################

LIBMEDIASOUPCLIENT_VERSION = 58dba679f5c4f50546d244fe98866b170ce1de07
LIBMEDIASOUPCLIENT_SITE = $(call github,versatica,libmediasoupclient,$(LIBMEDIASOUPCLIENT_VERSION))
LIBMEDIASOUPCLIENT_LICENSE = ISC
LIBMEDIASOUPCLIENT_LICENSE_FILES = LICENCE
LIBMEDIASOUPCLIENT_INSTALL_STAGING = YES
LIBMEDIASOUPCLIENT_DEPENDENCIES = host-pkgconf libsdptransform json-for-modern-cpp libwebrtc

LIBMEDIASOUPCLIENT_CONF_OPTS += \
	-DSDPTRANSFORM_ROOT_DIR=$(STAGING_DIR)/usr \
	-DWEBRTC_INCLUDE_DIR=$(STAGING_DIR)/usr/include/libwebrtc \
	-DWEBRTC_LIBRARY_DIR=$(STAGING_DIR)/usr/lib \
	-DJSON_ROOT_DIR=$(STAGING_DIR)/usr \
	-DMEDIASOUPCLIENT_BUILD_TESTS=OFF \
	-DMEDIASOUPCLIENT_LOG_TRACE=OFF \
	-DMEDIASOUPCLIENT_LOG_DEV=OFF

$(eval $(cmake-package))
