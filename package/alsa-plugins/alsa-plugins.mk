#############################################################
#
# alsa-plugins
#
#############################################################
ALSA_PLUGINS_VERSION = 1.1.9
ALSA_PLUGINS_SOURCE = alsa-plugins-$(ALSA_PLUGINS_VERSION).tar.bz2
ALSA_PLUGINS_SITE = ftp://ftp.alsa-project.org/pub/plugins
ALSA_PLUGINS_LICENSE = GPL-2.0
ALSA_PLUGINS_LICENSE_FILES = COPYING
ALSA_PLUGINS_INSTALL_STAGING = YES
ALSA_LIB_CFLAGS = $(TARGET_CFLAGS)

ALSA_PLUGINS_SECTION = audio
ALSA_PLUGINS_DESCRIPTION = Advanced Linux Sound Architecture plugins
ALSA_PLUGINS_DEPENDENCIES = alsa-lib

ALSA_PLUGINS_CONF_OPTS += --with-plugindir=/usr/lib/alsa-lib \
	--localstatedir=/var \
	--disable-oss \
	--disable-mix \
	--disable-usbstream \
	--disable-arcamav \
	--disable-avcodec \
	--disable-a52 \
	--disable-libav \
	--disable-lavrate

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
ALSA_PLUGINS_CONF_OPTS += --enable-pulseaudio
ALSA_PLUGINS_DEPENDENCIES += pulseaudio
else
ALSA_PLUGINS_CONF_OPTS += --disable-pulseaudio
endif

ifeq ($(BR2_PACKAGE_JACK2),y)
ALSA_PLUGINS_CONF_OPTS += --enable-jack
ALSA_PLUGINS_DEPENDENCIES += jack2
else
ALSA_PLUGINS_CONF_OPTS += --disable-jack
endif

ifeq ($(BR2_PACKAGE_LIBSAMPLERATE),y)
ALSA_PLUGINS_CONF_OPTS += --enable-samplerate
ALSA_PLUGINS_DEPENDENCIES += libsamplerate
else
ALSA_PLUGINS_CONF_OPTS += --disable-samplerate
endif

ifeq ($(BR2_PACKAGE_SPEEXDSP),y)
ALSA_PLUGINS_CONF_OPTS += --enable-speexdsp
ALSA_PLUGINS_DEPENDENCIES += speexdsp
else
ALSA_PLUGINS_CONF_OPTS += --disable-speexdsp
endif

$(eval $(autotools-package))
