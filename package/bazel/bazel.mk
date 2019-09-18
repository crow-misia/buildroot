################################################################################
#
# bazel
#
################################################################################

BAZEL_VERSION = 0.29.1
BAZEL_SITE = https://github.com/bazelbuild/bazel/releases/download/$(BAZEL_VERSION)
BAZEL_SOURCE = bazel-$(BAZEL_VERSION)-dist.zip

BAZEL_LICENSE = Apache-2.0
BAZEL_LICENSE_FILES = LICENSE

HOST_BAZEL_DEPENDENCIES = \
	toolchain \
	host-openjdk-bin

HOST_BAZEL_ROOT = $(HOST_DIR)/lib/bazel-$(BAZEL_VERSION)

define HOST_BAZEL_EXTRACT_CMDS
        $(UNZIP) -d $(@D) $(HOST_BAZEL_DL_DIR)/$(HOST_BAZEL_SOURCE)
endef

define HOST_BAZEL_BUILD_CMDS
	(cd $(@D); \
		rm $(HOST_DIR)/usr; \
		env JAVA_HOME="$(HOST_DIR)" EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk" bash ./compile.sh; \
		ln -sf . $(HOST_DIR)/usr \
	)
endef

define HOST_BAZEL_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/output/bazel $(HOST_DIR)/bin/bazel
endef

$(eval $(host-generic-package))
