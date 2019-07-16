################################################################################
#
# nats-server
#
################################################################################

NATS_SERVER_VERSION = 2.0.2
NATS_SERVER_SITE = $(call github,nats-io,nats-server,v$(NATS_SERVER_VERSION))
NATS_SERVER_WORKSPACE = gopath

NATS_SERVER_LICENSE = Apache-2.0
NATS_SERVER_LICENSE_FILES = LICENSE

NATS_SERVER_TAGS = autogen
NATS_SERVER_DEPENDENCIES = host-pkgconf

NATS_SERVER_LDFLAGS = -X main.Version=$(GNATSD_VERSION)

define NATS_SERVER_INSTALL_TARGET_CMDS
        $(INSTALL) -D -m 0755 $(@D)/bin/nats-server $(TARGET_DIR)/usr/bin/nats-server
endef

$(eval $(golang-package))
