# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="Gstreamer freescale plugins"
HOMEPAGE="https://freescale.github.io"
SRC_URI="http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/${P}.tar.gz
		http://git.yoctoproject.org/cgit/cgit.cgi/meta-fsl-arm/plain/recipes-multimedia/gstreamer/gst-fsl-plugin/Remove-use-of-obsolete-VIDIOC_DBG_G_CHIP_IDENT.patch?id=a3a6ca336023d41400e130f0d21fa35e0f67a6ea -> Remove-use-of-obsolete-VIDIOC_DBG_G_CHIP_IDENT.patch
		http://git.yoctoproject.org/cgit/cgit.cgi/meta-fsl-arm/plain/recipes-multimedia/gstreamer/gst-fsl-plugin/configure.ac-Fix-query-of-CFLAGS-to-pkgconfig.patch?id=a3a6ca336023d41400e130f0d21fa35e0f67a6ea -> configure.ac-Fix-query-of-CFLAGS-to-pkgconfig.patch"

LICENSE="GPL-2 LGPL-2 LGPL-2.1"
SLOT="0.10"
KEYWORDS="~arm"
IUSE="+aac +aacplus +ac3 +aiur +amr +beep +encode +h264 +mp3 +mpeg2 +mpeg4 +v4l +vorbis +wma +wmv +X"

DEPEND="media-libs/libfslvpuwrap
	media-libs/libfslaacpcodec
	media-libs/libfslcodec
	media-libs/libfslparser
	sys-libs/imx-lib
	media-libs/imx-vpu
	media-libs/gstreamer:0.10
	dev-libs/glib:2"

RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${DISTDIR}/Remove-use-of-obsolete-VIDIOC_DBG_G_CHIP_IDENT.patch"
	epatch "${DISTDIR}/configure.ac-Fix-query-of-CFLAGS-to-pkgconfig.patch"
	epatch "${FILESDIR}/fix_includes.patch"
}

src_configure() {
	my_conf=""
	use encode && (
		my_conf="$my_conf $(use_enable mp3 mp3enc)"
		my_conf="$my_conf $(use_enable wma wma8enc)"
	)
	econf PLATFORM=MX6 \
		$(use_enable aac aacdec) \
		$(use_enable aacplus aacpdec) \
		$(use_enable mp3 mp3dec) \
		$(use_enable vorbis vorbisdec) \
		$(use_enable wma wma10dec) \
		$(use_enable ac3 ac3dec) \
		$(use_enable amr amrdec) \
		$(use_enable h264 h264dec) \
		$(use_enable mpeg4 mpeg4dec) \
		$(use_enable mpeg2 mpeg2dec) \
		$(use_enable wmv wmv9mpdec) \
		$(use_enable wmv wmv78dec) \
		$(use_enable aiur) \
		$(use_enable beep) \
		$(use_enable v4l v4lsink) \
		$(use_enable X x11) \
		$my_conf \
		--enable-isink --enable-ipucsc --enable-ipulib
}
