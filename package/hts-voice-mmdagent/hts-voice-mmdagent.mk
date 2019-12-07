################################################################################
#
# HTS voice MMDAgent
#
################################################################################

HTS_VOICE_MMDAGENT_VERSION = 1.8
HTS_VOICE_MMDAGENT_SITE = https://sourceforge.net/projects/mmdagent/files
HTS_VOICE_MMDAGENT_SOURCE = MMDAgent_Example-$(HTS_VOICE_MMDAGENT_VERSION).zip
HTS_VOICE_MMDAGENT_LICENSE = CC-BY-3.0
HTS_VOICE_MMDAGENT_DEPENDENCIES = hts-engine

ifeq ($(BR2_PACKAGE_HTS_VOICE_MMDAGENT_MEI),y)
	HTS_VOICE_MMDAGENT_LICENSE_FILES += Voice/mei/COPYRIGHT.txt
endif

ifeq ($(BR2_PACKAGE_HTS_VOICE_MMDAGENT_TAKUMI),y)
        HTS_VOICE_MMDAGENT_LICENSE_FILES += Voice/takumi/COPYRIGHT.txt
endif

HTS_VOICE_MMDAGENT_TARGETS_$(BR2_PACKAGE_HTS_VOICE_MMDAGENT_MEI_ANGRY) += mei/mei_angry.htsvoice
HTS_VOICE_MMDAGENT_TARGETS_$(BR2_PACKAGE_HTS_VOICE_MMDAGENT_MEI_BASHFUL) += mei/mei_bashful.htsvoice
HTS_VOICE_MMDAGENT_TARGETS_$(BR2_PACKAGE_HTS_VOICE_MMDAGENT_MEI_HAPPY) += mei/mei_happy.htsvoice
HTS_VOICE_MMDAGENT_TARGETS_$(BR2_PACKAGE_HTS_VOICE_MMDAGENT_MEI_NORMAL) += mei/mei_normal.htsvoice
HTS_VOICE_MMDAGENT_TARGETS_$(BR2_PACKAGE_HTS_VOICE_MMDAGENT_MEI_SAD) += mei/mei_sad.htsvoice
HTS_VOICE_MMDAGENT_TARGETS_$(BR2_PACKAGE_HTS_VOICE_MMDAGENT_TAKUMI_ANGRY) += takumi/takumi_angry.htsvoice
HTS_VOICE_MMDAGENT_TARGETS_$(BR2_PACKAGE_HTS_VOICE_MMDAGENT_TAKUMI_HAPPY) += takumi/takumi_happy.htsvoice
HTS_VOICE_MMDAGENT_TARGETS_$(BR2_PACKAGE_HTS_VOICE_MMDAGENT_TAKUMI_NORMAL) += takumi/takumi_normal.htsvoice
HTS_VOICE_MMDAGENT_TARGETS_$(BR2_PACKAGE_HTS_VOICE_MMDAGENT_TAKUMI_SAD) += takumi/takumi_sad.htsvoice

define HTS_VOICE_MMDAGENT_EXTRACT_CMDS
	unzip -q $(HTS_VOICE_MMDAGENT_DL_DIR)/$(HTS_VOICE_MMDAGENT_SOURCE) -d $(@D)
	mv $(@D)/MMDAgent_Example-$(HTS_VOICE_MMDAGENT_VERSION)/* $(@D)
	rm -rf $(@D)/MMDAgent_Example-$(HTS_VOICE_MMDAGENT_VERSION)
endef

define HTS_VOICE_MMDAGENT_INSTALL_TARGET_CMDS
	for i in $(HTS_VOICE_MMDAGENT_TARGETS_y); do \
		$(INSTALL) -D -m 644 $(@D)/Voice/$$i $(TARGET_DIR)/usr/share/htsvoice/$$(basename $$i) || exit 1; \
	done
endef

$(eval $(generic-package))
