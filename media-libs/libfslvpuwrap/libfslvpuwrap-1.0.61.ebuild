# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils unpacker

DESCRIPTION="Freescale Multimedia VPU wrapper"
HOMEPAGE="https://freescale.github.io"
SRC_URI="http://www.nxp.com/lgfiles/NMG/MAD/YOCTO/${P}.bin"

LICENSE="Freescale"
SLOT="0"

KEYWORDS="~arm"

IUSE="examples"
DEPEND="media-libs/imx-vpu"
RDEPEND="${DEPEND}"

src_unpack()
{
	sh "${DISTDIR}/${P}.bin" --force --auto-accept || die
}

src_install()
{
	einstall
	einstalldocs
	use examples || rm -fr "${D}/usr/share/imx-mm"
}
