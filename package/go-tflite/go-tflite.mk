################################################################################
#
# go-tflite
#
################################################################################

GO_TFLITE_VERSION = 11e8959f01a963f78316c6f2d9d15e16c3ab25e9
GO_TFLITE_SITE = $(call github,mattn,go-tflite,$(GO_TFLITE_VERSION))

GO_TFLITE_DEPENDENCIES = tensorflow-lite

GO_TFLITE_BUILD_TARGETS = _example/pose

GO_TFLITE_INSTALL_BINS = pose

define GO_TFLITE_DOWNLOAD_MODULES
	cd $(@D); $(GO_BIN) get -u all; $(HOST_GO_HOST_ENV) GOPROXY= $(GO_BIN) mod download; $(HOST_GO_HOST_ENV) GOPROXY= $(GO_BIN) mod vendor
endef

GO_TFLITE_POST_PATCH_HOOKS += GO_TFLITE_DOWNLOAD_MODULES

$(eval $(golang-package))
