# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="Freescale Multimedia codec libs"
HOMEPAGE="https://freescale.github.io"

SRC_URI="http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/${P}.bin"
LICENSE="Freescale-3rd_party"
SLOT="0"
KEYWORDS="~arm"
IUSE="+aac +amrnb +amrwb +bmp +bsac doc +encode examples +flac +gif +g711 +g723 +g726 +g729 +h264 +jpeg +mp3 +mpeg2 +mpeg4 +peq +png +sbc +vorbis"

# Libraries linked in precompiled binaries
RDEPEND="sys-devel/gcc
	sys-libs/glibc"

src_unpack()
{
	sh "${DISTDIR}/${P}.bin" --force --auto-accept || die
}

src_configure()
{
	my_conf=""
	use encode && my_conf="$(use_enable jpeg jpegenc) $(use_enable mp3 mp3enc) $(use_enable sbc sbcenc)"
	if [ "$(tc-is-softfloat)" == "no" ]
	then
		my_conf="$my_conf --enable-fhw"
	fi
	econf --enable-vpu \
		$(use_enable aac aacdec) \
		$(use_enable amrnb) \
		$(use_enable amrwb) \
		$(use_enable bmp bmpdec) \
		$(use_enable bsac bsacdec) \
		$(use_enable flac flacdec) \
		$(use_enable gif gifdec) \
		$(use_enable g711) \
		$(use_enable g723) \
		$(use_enable g726) \
		$(use_enable g729) \
		$(use_enable h264 h264dec) \
		$(use_enable jpeg jpegdec) \
		$(use_enable mp3 mp3dec) \
		$(use_enable mpeg2 mpeg2dec) \
		$(use_enable mpeg4 mpeg4aspdec) \
		$(use_enable peq) \
		$(use_enable png pngdec) \
		$(use_enable vorbis vorbisdec) \
		$my_conf
}

src_install()
{
	einstall
	doenvd "${FILESDIR}/99-libfslcodec"
	use doc || rm -fr "${D}/usr/share/doc/libfslcodec"
	use examples || rm -fr "${D}/usr/share/imx-mm"
}
