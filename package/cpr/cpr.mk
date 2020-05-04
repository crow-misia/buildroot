################################################################################
#
# cpr
#
################################################################################

CPR_VERSION = 1.4.0
CPR_SITE = $(call github,whoshuu,cpr,$(CPR_VERSION))
CPR_LICENSE = MIT
CPR_LICENSE_FILES = LICENCE
CPR_INSTALL_STAGING = YES
CPR_DEPENDENCIES = host-pkgconf libcurl

CPR_CONF_OPTS += \
	-DUSE_SYSTEM_CURL=ON \
	-DBUILD_CPR_TESTS=OFF \
	-DBUILD_SHARED_LIBS=OFF
$(eval $(cmake-package))
