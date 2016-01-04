# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils unpacker

DESCRIPTION="Freescale Multimedia VPU wrapper"
HOMEPAGE="https://freescale.github.io"
SRC_URI="http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/${P}.bin"

LICENSE="Freescale-3rd_party"
SLOT="0"

KEYWORDS="~arm"

IUSE="examples"
DEPEND="|| ( media-libs/imx-lib >=media-libs/imx-vpu-5 )"
RDEPEND="${DEPEND}"

src_unpack()
{
	unpack_makeself ${A} 684 tail
}

src_install()
{
	einstall
	einstalldocs
	use examples || rm -fr "${D}/usr/share/imx-mm"
}
