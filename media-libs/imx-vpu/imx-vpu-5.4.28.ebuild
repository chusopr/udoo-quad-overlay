# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils unpacker

DESCRIPTION="Freescale VPU library"
HOMEPAGE="https://freescale.github.io"

SRC_URI="http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/${P}.bin"

LICENSE="Freescale-3rd_party"

SLOT="0"

KEYWORDS="~arm"

RESTRICT="strip mirror"

DEPEND="sys-kernel/firmware-imx media-libs/imx-gpu-viv"
RDEPEND="${DEPEND}"

src_unpack() {
	sh "${DISTDIR}/${A}" --force --auto-accept || die
}

src_compile() {
	export PLATFORM="IMX6Q"
	emake
}

src_install() {
	export PLATFORM="IMX6Q"
	emake DEST_DIR="${D}" install
}
