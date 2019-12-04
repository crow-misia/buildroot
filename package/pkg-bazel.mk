################################################################################
# Bazel package infrastructure
#
# This file implements an infrastructure that eases development of package .mk
# files for Bazel packages. It should be used for all packages that
# use Bazel as their build system.
#
# See the Buildroot documentation for details on the usage of this
# infrastructure
#
# In terms of implementation, this bazel infrastructure requires the .mk file
# to only specify metadata information about the package: name, version,
# download URL, etc.
#
# We still allow the package .mk file to override what the different steps are
# doing, if needed. For example, if <PKG>_BUILD_CMDS is already defined, it is
# used as the list of commands to perform to build the package, instead of the
# default golang behavior. The package can also define some post operation
# hooks.
#
################################################################################

BAZEL_BIN = $(HOST_DIR)/bin/bazel

################################################################################
# inner-golang-package -- defines how the configuration, compilation and
# installation of a Go package should be done, implements a few hooks to tune
# the build process for Go specificities and calls the generic package
# infrastructure to generate the necessary make targets
#
#  argument 1 is the lowercase package name
#  argument 2 is the uppercase package name, including a HOST_ prefix for host
#             packages
#  argument 3 is the uppercase package name, without the HOST_ prefix for host
#             packages
#  argument 4 is the type (target or host)
#
################################################################################

define inner-bazel-package

# Target packages need the Bazel on the host.
$(2)_DEPENDENCIES += host-bazel

# Build step. Only define it if not already defined by the package .mk
# file.
ifndef $(2)_BUILD_CMDS
ifeq ($(4),target)

# Build package for target
define $(2)_BUILD_CMDS
	cd $$($(2)_SRCDIR); \
	$$($(2)_BAZEL_ENV) \
	JAVA_HOME='$(HOST_DIR)' \
	$$(BAZEL_BIN) build $$($(2)_BUILD_OPTS)
endef
else
# Build package for host
define $(2)_BUILD_CMDS
	cd $$($(2)_SRCDIR); \
	$$($(2)_BAZEL_ENV) \
	JAVA_HOME='$(HOST_DIR)' \
	$$(BAZEL_BIN) build $$($(2)_BUILD_OPTS)
endef
endif
endif

# Call the generic package infrastructure to generate the necessary make
# targets
$(call inner-generic-package,$(1),$(2),$(3),$(4))

endef # inner-bazel-package

################################################################################
# bazel-package -- the target generator macro for Bazel packages
################################################################################

bazel-package = $(call inner-bazel-package,$(pkgname),$(call UPPERCASE,$(pkgname)),$(call UPPERCASE,$(pkgname)),target)
host-bazel-package = $(call inner-bazel-package,host-$(pkgname),$(call UPPERCASE,host-$(pkgname)),$(call UPPERCASE,$(pkgname)),host)
