################################################################################
#
# cli11
#
################################################################################

CLI11_VERSION = 1.9.0
CLI11_SITE = $(call github,CLIUtils,CLI11,v$(CLI11_VERSION))
CLI11_LICENSE = BSD-3
CLI11_LICENSE_FILES = LICENSE
CLI11_INSTALL_STAGING = YES

$(eval $(cmake-package))
