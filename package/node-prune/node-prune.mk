################################################################################
#
# node-prune
#
################################################################################

NODE_PRUNE_VERSION = 1.2.0
NODE_PRUNE_SITE = $(call github,tj,node-prune,v$(NODE_PRUNE_VERSION))
NODE_PRUNE_LICENSE = MIT
NODE_PRUNE_LICENSE_FILES = LICENSE

NODE_PRUNE_LDFLAGS = -X main.Version=$(NODE_PRUNE_VERSION)

HOST_NODE_PRUNE_DEPENDENCIES = host-go

HOST_NODE_PRUNE_BIN_NAME = node-prune
HOST_NODE_PRUNE_INSTALL_BINS = $(HOST_NODE_PRUNE_BIN_NAME)

define HOST_NODE_PRUNE_DOWNLOAD_MODULES
	cd $(@D); $(GO_BIN) get -u all; $(HOST_GO_HOST_ENV) GOPROXY= $(GO_BIN) mod download; $(HOST_GO_HOST_ENV) GOPROXY= $(GO_BIN) mod vendor
endef

HOST_NODE_PRUNE_POST_PATCH_HOOKS += HOST_NODE_PRUNE_DOWNLOAD_MODULES

$(eval $(host-golang-package))
