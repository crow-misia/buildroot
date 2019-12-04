################################################################################
#
# tensorflow-lite
#
################################################################################

TENSORFLOW_LITE_VERSION = v1.15.0
TENSORFLOW_LITE_REPO_URL = https://github.com/tensorflow/tensorflow
TENSORFLOW_LITE_SITE = $(call qstrip,$(TENSORFLOW_LITE_REPO_URL))
TENSORFLOW_LITE_SITE_METHOD = git
TENSORFLOW_LITE_SUBDIR = tensorflow/lite

TENSORFLOW_LITE_LICENSE = Apache-2.0
TENSORFLOW_LITE_LICENSE_FILES = LICENSE

TENSORFLOW_LITE_INSTALL_STAGING = YES

TENSORFLOW_LITE_DEPENDENCIES = \
        toolchain \
        host-python3

define TENSORFLOW_LITE_COPY_GIT
	cp -rf $(TENSORFLOW_LITE_DL_DIR)/git/{.git,.gitignore} $(@D)
endef
TENSORFLOW_LITE_POST_EXTRACT_HOOKS += TENSORFLOW_LITE_COPY_GIT

define TENSORFLOW_LITE_CONFIGURE_CMDS
	mkdir -p $(@D)/third_party/toolchains/buildroot
	cp -f package/tensorflow-lite/{BUILD,CROSSTOOL} $(@D)/third_party/toolchains/buildroot
	sed -i -e 's#@TARGET_CROSS@#$(TARGET_CROSS)#' $(@D)/third_party/toolchains/buildroot/CROSSTOOL
	sed -i -e 's#@TOOLCHAIN_ID@#$(shell basename $(realpath $(STAGING_DIR)/../))#' $(@D)/third_party/toolchains/buildroot/CROSSTOOL
	sed -i -e 's#@GCC_VERSION@#$(GCC_VERSION)#' $(@D)/third_party/toolchains/buildroot/CROSSTOOL
	sed -i -e 's#@HOST_DIR@#$(HOST_DIR)#' $(@D)/third_party/toolchains/buildroot/CROSSTOOL
	cp -f package/tensorflow-lite/tf_configure.bazelrc $(@D)/.tf_configure.bazelrc
	sed -i -e 's#@PYTHON_BIN@#$(HOST_DIR)/bin/python3#' $(@D)/.tf_configure.bazelrc
	sed -i -e 's#@PYTHON_LIB@#$(HOST_DIR)/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages#' $(@D)/.tf_configure.bazelrc
endef

TENSORFLOW_LITE_BUILD_OPTS += \
	--verbose_failures \
	-c opt \
	--copt=-mfpu=neon-fp16 \
	--cpu='armeabi-v7a' \
	--crosstool_top='//third_party/toolchains/buildroot:toolchain' \
	--host_crosstool_top='@bazel_tools//tools/cpp:toolchain' \
	//tensorflow/lite:libtensorflowlite.so

define TENSORFLOW_LITE_BUILD_C_API
	$(TARGET_CXX) $(TARGET_CXXFLAGS) -fPIC $(TARGET_LDFLAGS) \
		$(@D)/tensorflow/lite/experimental/c/c_api.cc \
		$(@D)/tensorflow/lite/experimental/c/c_api_experimental.cc \
		-I$(@D) \
		-I$(@D)/bazel-genfiles \
		-I$(@D)/bazel-tensorflow-lite-$(TENSORFLOW_LITE_VERSION)/external/flatbuffers/include \
		-L$(@D)/bazel-bin/tensorflow/lite \
		-ltensorflowlite \
		-shared \
		-o $(@D)/libtensorflowlite_c.so
endef
TENSORFLOW_LITE_POST_BUILD_HOOKS += TENSORFLOW_LITE_BUILD_C_API

define TENSORFLOW_LITE_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bazel-bin/tensorflow/lite/libtensorflowlite.so $(STAGING_DIR)/usr/lib/libtensorflowlite.so
	$(INSTALL) -D -m 0755 $(@D)/libtensorflowlite_c.so $(STAGING_DIR)/usr/lib/libtensorflowlite_c.so
	cd $(@D)                && find tensorflow/lite -follow -type f -name "*.h" -exec cp --parents {} $(STAGING_DIR)/usr/include \;
	cd $(@D)/bazel-genfiles && find tensorflow      -follow -type f -name "*.h" -exec cp --parents {} $(STAGING_DIR)/usr/include \;
	cd $(@D)/bazel-tensorflow-lite-$(TENSORFLOW_LITE_VERSION)/external/flatbuffers/include && find flatbuffers -follow -type f -name "*.h" -exec cp --parents {} $(STAGING_DIR)/usr/include \;
endef

define TENSORFLOW_LITE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bazel-bin/tensorflow/lite/libtensorflowlite.so $(TARGET_DIR)/usr/lib/libtensorflowlite.so
	$(INSTALL) -D -m 0755 $(@D)/libtensorflowlite_c.so $(TARGET_DIR)/usr/lib/libtensorflowlite_c.so
endef

$(eval $(bazel-package))

