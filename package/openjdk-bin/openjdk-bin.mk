################################################################################
#
# host-openjdk-bin
#
################################################################################

HOST_OPENJDK_BIN_VERSION_MAJOR = 13
HOST_OPENJDK_BIN_VERSION_MINOR = 33_openj9-0.16.0
HOST_OPENJDK_BIN_VERSION = $(HOST_OPENJDK_BIN_VERSION_MAJOR)_$(HOST_OPENJDK_BIN_VERSION_MINOR)
HOST_OPENJDK_BIN_SOURCE = OpenJDK13U-jdk_x64_linux_openj9_$(HOST_OPENJDK_BIN_VERSION).tar.gz
HOST_OPENJDK_BIN_SITE = https://github.com/AdoptOpenJDK/openjdk13-binaries/releases/download/jdk-$(HOST_OPENJDK_BIN_VERSION_MAJOR)%2B$(HOST_OPENJDK_BIN_VERSION_MINOR)
HOST_OPENJDK_BIN_LICENSE = GPL-2.0+ with exception
HOST_OPENJDK_BIN_LICENSE_FILES = legal/java.prefs/LICENSE legal/java.prefs/ASSEMBLY_EXCEPTION

# unpack200 has an invalid RPATH and relies on libzlib. When
# host-libzlib is installed on the system, the error "ERROR: package
# host-libzlib installs executables without proper RPATH: will occur.
# Because unpack200 is a deprecated tool, removing it to fix this
# issue is safe.
define HOST_OPENJDK_BIN_INSTALL_CMDS
	cp -dpfr $(@D)/bin/* $(HOST_DIR)/bin/
	cp -dpfr $(@D)/lib/* $(HOST_DIR)/lib/
	cp -dpfr $(@D)/include/* $(HOST_DIR)/include/
	$(RM) -f $(HOST_DIR)/bin/unpack200
endef

$(eval $(host-generic-package))
