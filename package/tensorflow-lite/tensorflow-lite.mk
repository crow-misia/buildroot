################################################################################
#
# tensorflow-lite
#
################################################################################

TENSORFLOW_LITE_VERSION = 2.2.0
TENSORFLOW_LITE_REPO_URL = https://github.com/tensorflow/tensorflow
TENSORFLOW_LITE_SITE = $(call github,tensorflow,tensorflow,v$(TENSORFLOW_LITE_VERSION))
TENSORFLOW_LITE_LICENSE = Apache-2.0
TENSORFLOW_LITE_LICENSE_FILES = LICENSE
TENSORFLOW_LITE_INSTALL_STAGING = YES
TENSORFLOW_LITE_DEPENDENCIES = \
        toolchain \
	zlib \
	host-python3 \
	host-python3-numpy


ifeq ($(BR2_arm),y)
# it also wants to know which FPU to use, but only has support for
# vfp, vfpv3, vfpv3-d16, vfpv4, vfpv4-d16 and neon.
ifeq ($(BR2_ARM_FPU_VFPV2),y)
TENSORFLOW_LITE_ARM_FPU = vfp
else ifeq ($(BR2_ARM_FPU_VFPV3),y)
TENSORFLOW_LITE_ARM_FPU = vfpv3
else ifeq ($(BR2_ARM_FPU_VFPV4),y)
TENSORFLOW_LITE_ARM_FPU = vfpv4
else ifeq ($(BR2_ARM_FPU_VFPV3D16),y)
TENSORFLOW_LITE_ARM_FPU = vfpv3-d16
else ifeq ($(BR2_ARM_FPU_VFPV4D16),y)
TENSORFLOW_LITE_ARM_FPU = vfpv4-d16
else ifeq ($(BR2_ARM_FPU_NEON),y)
TENSORFLOW_LITE_ARM_FPU = neon
endif
endif

TENSORFLOW_LITE_ARCH = $(call qstrip,$(BR2_ARCH))
TENSORFLOW_LITE_GEN_DIR = $(@D)/tensorflow/lite/tools/make/gen/$(TARGET_OS)_$(TENSORFLOW_LITE_ARCH)

TENSORFLOW_LITE_MAKE_OPTS = \
	TARGET=$(TARGET_OS) \
	TARGET_ARCH=$(TENSORFLOW_LITE_ARCH) \
	CFLAGS="$(TARGET_CFLAGS) -fPIC" \
	CXXFLAGS="$(TARGET_CXXFLAGS) -fPIC $(if $(TENSORFLOW_LITE_ARM_FPU),-mfpu=$(TENSORFLOW_LITE_ARM_FPU))"

TENSORFLOW_LITE_CXXFLAGS += \
	-DTF_COMPILE_LIBRARY \
	-I$(@D) \
	-I$(@D)/tensorflow/lite/tools/make/downloads/flatbuffers/include \
	-I$(@D)/tensorflow/lite/tools/make/downloads/absl

define TENSORFLOW_LITE_BUILD_CMDS
        $(@D)/tensorflow/lite/tools/make/download_dependencies.sh
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) $(TENSORFLOW_LITE_MAKE_OPTS) -C $(@D) -f $(@D)/tensorflow/lite/tools/make/Makefile
	$(TARGET_CXX) -std=c++14 -c $(TENSORFLOW_LITE_CXXFLAGS) -o $(TENSORFLOW_LITE_GEN_DIR)/obj/tensorflow/lite/c/c_api.o $(@D)/tensorflow/lite/c/c_api.cc
	$(TARGET_CXX) -std=c++14 -c $(TENSORFLOW_LITE_CXXFLAGS) -o $(TENSORFLOW_LITE_GEN_DIR)/obj/tensorflow/lite/c/c_api_experimental.o $(@D)/tensorflow/lite/c/c_api_experimental.cc 
	$(TARGET_CXX) -shared -o $(TENSORFLOW_LITE_GEN_DIR)/lib/libtensorflowlite_c.so \
		-fPIC \
		$(TENSORFLOW_LITE_GEN_DIR)/obj/tensorflow/lite/c/c_api.o \
		$(TENSORFLOW_LITE_GEN_DIR)/obj/tensorflow/lite/c/c_api_experimental.o \
		-L$(TENSORFLOW_LITE_GEN_DIR)/lib -ltensorflow-lite
endef

define TENSORFLOW_LITE_INSTALL_STAGING_CMDS
	$(INSTALL) -m 0755 $(TENSORFLOW_LITE_GEN_DIR)/lib/libtensorflowlite_c.so $(STAGING_DIR)/usr/lib/
	cd $(@D)                && find tensorflow/lite -follow -type f -name "*.h" -exec cp --parents {} $(STAGING_DIR)/usr/include \;
endef

define TENSORFLOW_LITE_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/tensorflow/lite/tools/make/gen/$(TARGET_OS)_$(BR2_ARCH)/lib/libtensorflowlite_c.so $(TARGET_DIR)/usr/lib/
endef

$(eval $(generic-package))
