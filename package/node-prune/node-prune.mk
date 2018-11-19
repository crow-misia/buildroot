################################################################################
#
# node-prune
#
################################################################################

NODE_PRUNE_VERSION = 1.0.1
NODE_PRUNE_COMMIT = ea363c1e0d198f9e8314051d0c25c66c57606f0e
NODE_PRUNE_SITE = $(call github,tj,node-prune,$(NODE_PRUNE_COMMIT))

NODE_PRUNE_LICENSE = MIT
NODE_PRUNE_LICENSE_FILES = LICENSE

HOST_NODE_PRUNE_DEPENDENCIES = host-go
HOST_NODE_PRUNE_ROOT = $(HOST_DIR)/lib/go

HOST_NODE_PRUNE_GOPATH=$(STAGING_DIR)/golang

define HOST_NODE_PRUNE_BUILD_CMDS
	(GOPATH=$(HOST_NODE_PRUNE_GOPATH) $(HOST_DIR)/bin/go get github.com/apex/log)
	(GOPATH=$(HOST_NODE_PRUNE_GOPATH) $(HOST_DIR)/bin/go get github.com/dustin/go-humanize)
	(GOPATH=$(HOST_NODE_PRUNE_GOPATH) $(HOST_DIR)/bin/go get github.com/fatih/color)
	(GOPATH=$(HOST_NODE_PRUNE_GOPATH) $(HOST_DIR)/bin/go get github.com/mattn/go-colorable)
	(GOPATH=$(HOST_NODE_PRUNE_GOPATH) $(HOST_DIR)/bin/go get github.com/tj/node-prune)
	cd $(@D) && (GOPATH=$(HOST_NODE_PRUNE_GOPATH) $(HOST_DIR)/bin/go build $(@D)/cmd/node-prune/main.go)
endef

define HOST_NODE_PRUNE_INSTALL_CMDS
        $(INSTALL) -D -m 0755 $(@D)/main $(HOST_DIR)/bin/node-prune
endef

$(eval $(host-generic-package))

