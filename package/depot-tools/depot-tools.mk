################################################################################
#
# depot_tools
#
################################################################################

DEPOT_TOOLS_VERSION = 6c484875cdcbfeba43a4fae0106a1be8ca65eff1
DEPOT_TOOLS_SITE = https://chromium.googlesource.com/chromium/tools/depot_tools.git
DEPOT_TOOLS_SITE_METHOD = git

DEPOT_TOOLS_LICENSE = BSD-3-Clause
DEPOT_TOOLS_LICENSE_FILES = LICENSE

HOST_DEPOT_TOOLS_DEPENDENCIES = host-python

define HOST_DEPOT_TOOLS_INSTALL_CMDS
	mkdir -p $(HOST_DIR)/depot_tools/
	cp -dpfr $(@D)/* $(HOST_DIR)/depot_tools/
endef

$(eval $(host-generic-package))
