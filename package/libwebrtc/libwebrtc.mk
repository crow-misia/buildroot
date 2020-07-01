################################################################################
#
# libwebrtc
#
################################################################################

LIBWEBRTC_VERSION = d01b162f308740e23b480eb837d1a6587f9c0ef8
LIBWEBRTC_SOURCE =
LIBWEBRTC_LICENSE = BSD-3-Clause
LIBWEBRTC_LICENSE_FILES = src/LICENSE src/PATENTS

LIBWEBRTC_DEPENDENCIES = host-depot-tools host-ca-certificates

LIBWEBRTC_INSTALL_STAGING = YES
LIBWEBRTC_INSTALL_TARGET = NO

DEPOT_TOOLS = $(HOST_DIR)/depot_tools/

LIBWEBRTC_PATH = $(@D)/bin:$(DEPOT_TOOLS):$(BR_PATH)

define LIBWEBRTC_FETCH_CMD
	mkdir -p $(@D)/bin
	ln -sf $(HOST_DIR)/bin/python2 $(@D)/bin/python

	mkdir -p $(LIBWEBRTC_DL_DIR) && \
	export PATH="$(LIBWEBRTC_PATH)" && \
	cd $(LIBWEBRTC_DL_DIR) && \
	if [ -f $(LIBWEBRTC_DL_DIR)/.gclient ]; then \
	  gclient sync --nohooks; \
	else \
	  fetch --nohooks webrtc; \
	fi
endef

LIBWEBRTC_POST_DOWNLOAD_HOOKS += LIBWEBRTC_FETCH_CMD

define LIBWEBRTC_EXTRACT_CMDS
	mkdir -p $(@D)/patch
        cp -r package/libwebrtc/patch/*.patch $(@D)/patch/

	export SSL_CERT_DIR="$(HOST_DIR)/etc/ssl/certs" && \
	export PATH="$(LIBWEBRTC_PATH)" && \
	rsync -au --chmod=u=rwX,go=rX $(call qstrip,$(LIBWEBRTC_DL_DIR))/ $(@D) && \
	cd $(@D)/src && \
	./build/linux/sysroot_scripts/install-sysroot.py --arch=$(BR2_ARCH) && \
	git fetch && \
	git checkout . && \
	git clean -df && \
	cd $(@D)/src/third_party && \
	git checkout . && \
	git clean -df && \
	cd $(@D)/src/third_party/depot_tools && \
	git checkout . && \
	git clean -df && \
	cd $(@D) && \
	gclient sync --with_branch_heads -r $(LIBWEBRTC_VERSION)

	cd $(@D)/src && \
	patch -p1 < ../patch/nacl_armv6_2.patch && \
	patch -p2 < ../patch/4k.patch && \
	patch -p2 < ../patch/macos_h264_encoder.patch
endef

ifeq ($(BR2_CCACHE),y)
	LIBWEBRTC_CC_WRAPPER = cc_wrapper=\"$(CCACHE)\"
endif

define LIBWEBRTC_BUILD_CMDS
	export PATH="$(LIBWEBRTC_PATH)" && \
	cd $(@D)/src && \
	gn gen $(@D)/out --args="$(LIBWEBRTC_CC_WRAPPER) target_os=\"linux\" target_cpu=\"$(call qstrip,$(BR2_ARCH))\" is_debug=false treat_warnings_as_errors=false rtc_use_h264=false rtc_use_x11=false rtc_include_tests=false rtc_build_examples=false is_desktop_linux=false rtc_build_json=true strip_debug_info=true use_rtti=true use_custom_libcxx=false use_custom_libcxx_for_host=false use_ozone=true" && \
	ninja -C $(@D)/out
endef

define LIBWEBRTC_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib
	$(INSTALL) -m 0755 -d $(STAGING_DIR)/usr/lib/
	$(INSTALL) -m 0644 $(@D)/out/obj/libwebrtc.a $(STAGING_DIR)/usr/lib/libwebrtc.a
	$(INSTALL) -m 0644 $(@D)/out/obj/third_party/boringssl/libboringssl.a $(STAGING_DIR)/usr/lib/libboringssl.a
	rm -rf $(STAGING_DIR)/usr/include/webrtc
	mkdir -p $(STAGING_DIR)/usr/include/webrtc

	$(INSTALL) -m 0644 -D $(@D)/src/*.h $(STAGING_DIR)/usr/include/webrtc/
	cd $(@D)/src && \
	for h in $$(find {api,audio,base,call,common_audio,common_video,logging,media,modules,p2p,pc,rtc_base,rtc_tools,system_wrappers,test,third_party,video} -type f -name '*.h'); do \
	  $(INSTALL) -m 0644 -D $$h $(STAGING_DIR)/usr/include/libwebrtc/$$h || exit 1; \
	done
	cd $(@D)/src && $(INSTALL) -m 0644 -D *.h $(STAGING_DIR)/usr/include/libwebrtc/

endef

$(eval $(generic-package))
