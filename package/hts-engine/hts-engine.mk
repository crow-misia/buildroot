################################################################################
#
# HTS Engine
#
################################################################################

HTS_ENGINE_VERSION = 1.10
HTS_ENGINE_SITE = https://sourceforge.net/projects/hts-engine/files
HTS_ENGINE_SOURCE = hts_engine_API-$(HTS_ENGINE_VERSION).tar.gz
HTS_ENGINE_LICENSE = BSD-3-Clause
HTS_ENGINE_LICENSE_FILES = COPYING
HTS_ENGINE_INSTALL_STAGING = YES
HTS_ENGINE_AUTORECONF = YES

define HTS_ENGINE_INSTALL_TARGET_CMDS
        $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
        rm -f $(TARGET_DIR)/usr/bin/hts_engine
endef

$(eval $(autotools-package))
$(eval $(host-autotools-package))
