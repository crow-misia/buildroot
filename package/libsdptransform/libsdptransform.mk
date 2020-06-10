################################################################################
#
# libsdptransform
#
################################################################################

LIBSDPTRANSFORM_VERSION = 1.2.7
LIBSDPTRANSFORM_SITE = $(call github,ibc,libsdptransform,$(LIBSDPTRANSFORM_VERSION))
LIBSDPTRANSFORM_LICENSE = MIT
LIBSDPTRANSFORM_LICENSE_FILES = LICENSE
LIBSDPTRANSFORM_INSTALL_STAGING = YES
LIBSDPTRANSFORM_DEPENDENCIES = host-pkgconf json-for-modern-cpp

LIBSDPTRANSFORM_CONF_OPTS += -DJSON_ROOT_DIR=$(STAGING_DIR)/usr

$(eval $(cmake-package))
