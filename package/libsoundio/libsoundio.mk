################################################################################
#
# libsoundio
#
################################################################################

LIBSOUNDIO_VERSION = 2.0.0
LIBSOUNDIO_SITE = $(call github,andrewrk,libsoundio,$(LIBSOUNDIO_VERSION))

LIBSOUNDIO_LICENSE = MIT
LIBSOUNDIO_LICENSE_FILES = LICENSE

LIBSOUNDIO_INSTALL_STAGING = YES

LIBSOUNDIO_DEPENDENCIES = \
        toolchain

LIBSOUNDIO_SUPPORTS_IN_SOURCE_BUILD = NO

$(eval $(cmake-package))

