################################################################################
#
# HTS voice nitech
#
################################################################################

HTS_VOICE_NITECH_VERSION = 1.05
HTS_VOICE_NITECH_SITE = https://sourceforge.net/projects/open-jtalk/files
HTS_VOICE_NITECH_SOURCE = hts_voice_nitech_jp_atr503_m001-$(HTS_VOICE_NITECH_VERSION).tar.gz
HTS_VOICE_NITECH_LICENSE = CC-BY-3.0
HTS_VOICE_NITECH_LICENSE_FILES = COPYING
HTS_VOICE_NITECH_DEPENDENCIES = hts-engine

define HTS_VOICE_NITECH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 644 $(@D)/nitech_jp_atr503_m001.htsvoice $(TARGET_DIR)/usr/share/htsvoice/nitech_jp_atr503_m001.htsvoice
endef

$(eval $(generic-package))
