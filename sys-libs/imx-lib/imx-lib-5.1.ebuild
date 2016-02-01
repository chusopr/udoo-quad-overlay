# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils udev

DESCRIPTION="Platform specific libraries for imx platform"
HOMEPAGE="https://freescale.github.io"
SRC_URI="http://www.nxp.com/lgfiles/NMG/MAD/YOCTO/${P}.tar.gz"
LICENSE="LGPL-2.1+"
SLOT="0"

KEYWORDS="~arm"
DEPEND="virtual/udev"

src_compile() {
	emake PLATFORM=IMX6Q pxp
	emake PLATFORM=IMX6Q ipu
}

src_install() {
	emake -C pxp DEST_DIR="${D}" install
	emake -C ipu DEST_DIR="${D}" install
	udev_dorules "${FILESDIR}/10-imx.rules"
}
