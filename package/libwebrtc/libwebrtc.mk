################################################################################
#
# libwebrtc
#
################################################################################

LIBWEBRTC_VERSION = 68c715dc01cd8cd0ad2726453e7376b5f353fcd1
LIBWEBRTC_SOURCE =
LIBWEBRTC_LICENSE = BSD-3-Clause
LIBWEBRTC_LICENSE_FILES = LICENSE

LIBWEBRTC_DEPENDENCIES = host-depot-tools

LIBWEBRTC_INSTALL_STAGING = YES
LIBWEBRTC_INSTALL_TARGET = NO

DEPOT_TOOLS = $(HOST_DIR)/depot_tools/

LIBWEBRTC_PATH = /bin:/usr/bin:$(BR_PATH):$(DEPOT_TOOLS)

define LIBWEBRTC_FETCH_CMD
	mkdir -p $(LIBWEBRTC_DL_DIR)
	if [ ! -f $(LIBWEBRTC_DL_DIR)/.gclient ]; then \
		cd $(LIBWEBRTC_DL_DIR); PATH=$(LIBWEBRTC_PATH) fetch --nohooks webrtc; \
	fi
	cd $(LIBWEBRTC_DL_DIR); PATH=$(LIBWEBRTC_PATH) gclient sync
endef

LIBWEBRTC_POST_DOWNLOAD_HOOKS += LIBWEBRTC_FETCH_CMD

define LIBWEBRTC_EXTRACT_CMDS
	rsync -au --chmod=u=rwX,go=rX $(call qstrip,$(LIBWEBRTC_DL_DIR))/ $(@D)
	cd $(@D)/src; PATH=$(LIBWEBRTC_PATH) ./build/linux/sysroot_scripts/install-sysroot.py --arch=$(BR2_ARCH)
	cd $(@D); PATH=$(LIBWEBRTC_PATH) gclient sync --with_branch_heads -r $(LIBWEBRTC_VERSION)
endef

ifeq ($(BR2_CCACHE),y)
	LIBWEBRTC_CC_WRAPPER = cc_wrapper=\"$(CCACHE)\"
endif

define LIBWEBRTC_BUILD_CMDS
	cd $(@D)/src; PATH=$(LIBWEBRTC_PATH) gn gen out/release --args="$(LIBWEBRTC_CC_WRAPPER) target_os=\"linux\" target_cpu=\"$(call qstrip,$(BR2_ARCH))\" is_debug=false symbol_level=0 use_custom_libcxx=false"
	cd $(@D)/src; PATH=$(LIBWEBRTC_PATH) ninja -C out/release webrtc
endef

define LIBWEBRTC_INSTALL_STAGING_CMDS
	$(INSTALL) -m 0644 -D $(@D)/src/out/release/obj/libwebrtc.a $(STAGING_DIR)/usr/lib/libwebrtc.a
	rm -rf $(STAGING_DIR)/usr/include/webrtc
	mkdir -p $(STAGING_DIR)/usr/include/webrtc

	$(INSTALL) -m 0644 -D $(@D)/src/*.h $(STAGING_DIR)/usr/include/webrtc/
	cd $(@D)/src; for h in $$(find {api,audio,base,build,call,common_audio,common_video,logging,media,modules,p2p,pc,rtc_base,rtc_tools,system_wrappers,video} -type f -name '*.h'); do \
		$(INSTALL) -m 0644 -D $$h $(STAGING_DIR)/usr/include/webrtc/$$h || exit 1; \
	done
	cd $(@D)/src/third_party/abseil-cpp; for h in $$(find . -type f -name '*.h'); do \
		$(INSTALL) -m 0644 -D $$h $(STAGING_DIR)/usr/include/webrtc/$$h || exit 1; \
	done 
endef

$(eval $(generic-package))
