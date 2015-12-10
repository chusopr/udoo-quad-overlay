# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="Freescale Multimedia parser libs"
HOMEPAGE="https://freescale.github.io"
SRC_URI="http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/${P}.bin"

LICENSE="Freescale-3rd_party"
SLOT="0"
KEYWORDS="~arm"
IUSE="+avi +avidrm +flv +mkv +mp3 +mp4 +mpeg2 +ogg"

# Libraries linked in precompiled binaries
RDEPEND="sys-devel/gcc
	sys-libs/glibc"

src_unpack() {
	sh "${DISTDIR}/${A}" --force --auto-accept || die
}

src_configure() {
	my_conf=""
	if [ "$(tc-is-softfloat)" == "no" ]
	then
		my_conf="$my_conf --enable-fhw"
	else
		my_conf="$my_conf --enable-fsw"
	fi
	econf \
		$(use_enable avi aviparser) \
		$(use_enable avidrm avidrmparser) \
		$(use_enable flv flvparser) \
		$(use_enable ogg oggparser) \
		$(use_enable mkv mkvparser) \
		$(use_enable mp3 mp3parser) \
		$(use_enable mp4 mp4parser) \
		$(use_enable mpeg2 mpg2parser) \
		$my_conf
}

src_install() {
	einstall
	doenvd "${FILESDIR}/99-libfslcodec"
}
