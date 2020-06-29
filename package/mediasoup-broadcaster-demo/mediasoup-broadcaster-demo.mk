################################################################################
#
# mediasoup-broadcaster-demo
#
################################################################################

MEDIASOUP_BROADCASTER_DEMO_VERSION = 474f4781a09d6573fc2284cfb94d20183f3475ee
MEDIASOUP_BROADCASTER_DEMO_SITE = $(call github,versatica,mediasoup-broadcaster-demo,$(MEDIASOUP_BROADCASTER_DEMO_VERSION))
MEDIASOUP_BROADCASTER_DEMO_INSTALL_STAGING = NO
MEDIASOUP_BROADCASTER_DEMO_DEPENDENCIES = host-pkgconf libmediasoupclient cpr json-for-modern-cpp libcurl

MEDIASOUP_BROADCASTER_DEMO_CONF_OPTS += \
	-DSDPTRANSFORM_ROOT_DIR=$(STAGING_DIR)/usr \
	-DWEBRTC_INCLUDE_DIR=$(STAGING_DIR)/usr/include/libwebrtc \
	-DWEBRTC_LIBRARY_DIR=$(STAGING_DIR)/usr/lib \
	-DMEDIASOUPCLIENT_ROOT_DIR=$(STAGING_DIR)/usr \
	-DCPR_ROOT_DIR=$(STAGING_DIR)/usr \
	-DJSON_ROOT_DIR=$(STAGING_DIR)/usr \
	-DCURL_BINARY_PATH=$(STAGING_DIR)/usr/lib

ifeq ($(BR2_PACKAGE_OPENSSL),y)
MEDIASOUP_BROADCASTER_DEMO_CONF_OPTS += \
	-DOPENSSL_INCLUDE_DIR:PATH=$(STAGING_DIR)/usr/include/openssl \
	-DCMAKE_USE_OPENSSL=ON
endif

$(eval $(cmake-package))
