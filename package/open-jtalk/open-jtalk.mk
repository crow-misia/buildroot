################################################################################
#
# Open JTalk
#
################################################################################

OPEN_JTALK_VERSION = 1.11
OPEN_JTALK_SITE = https://sourceforge.net/projects/open-jtalk/files
OPEN_JTALK_SOURCE = open_jtalk-$(OPEN_JTALK_VERSION).tar.gz
OPEN_JTALK_LICENSE = BSD-3-Clause
OPEN_JTALK_LICENSE_FILES = COPYING
OPEN_JTALK_DEPENDENCIES = hts-engine host-open-jtalk
OPEN_JTALK_AUTORECONF = YES

HOST_OPEN_JTALK_DEPENDENCIES = host-hts-engine

OPEN_JTALK_CONF_OPTS = \
	--with-hts-engine-header-path=$(STAGING_DIR)/usr/include \
	--with-hts-engine-library-path=$(STAGING_DIR)/usr/lib \
	--with-charset=UTF-8

HOST_OPEN_JTALK_CONF_OPTS = \
	--with-hts-engine-header-path=$(HOST_DIR)/usr/include \
	--with-hts-engine-library-path=$(HOST_DIR)/usr/lib \
	--with-charset=UTF-8

define OPEN_JTALK_COPY_DICT
	cp -f $(HOST_DIR)/usr/dic/* $(@D)/mecab-naist-jdic/
endef

OPEN_JTALK_PRE_BUILD_HOOKS += OPEN_JTALK_COPY_DICT

$(eval $(autotools-package))
$(eval $(host-autotools-package))
