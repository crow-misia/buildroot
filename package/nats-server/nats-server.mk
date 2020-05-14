################################################################################
#
# nats-server
#
################################################################################

NATS_SERVER_VERSION = 2.1.6
NATS_SERVER_SITE = $(call github,nats-io,nats-server,v$(NATS_SERVER_VERSION))
NATS_SERVER_LICENSE = Apache-2.0
NATS_SERVER_LICENSE_FILES = LICENSE

NATS_SERVER_LDFLAGS = -X main.Version=$(NATS_SERVER_VERSION)

NATS_SERVER_GOMOD = github.com/nats-io/nats-server/v2

define NATS_SERVER_DOWNLOAD_MODULES
	cd $(@D); $(GO_BIN) get -u all; $(HOST_GO_HOST_ENV) GOPROXY= $(GO_BIN) mod download; $(HOST_GO_HOST_ENV) GOPROXY= $(GO_BIN) mod vendor
endef

NATS_SERVER_POST_PATCH_HOOKS += NATS_SERVER_DOWNLOAD_MODULES

$(eval $(golang-package))
