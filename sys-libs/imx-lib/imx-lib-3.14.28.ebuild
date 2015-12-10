# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils udev

DESCRIPTION="Platform specific libraries for imx platform"
HOMEPAGE="https://freescale.github.io"
SRC_URI="
	http://repository.timesys.com/buildsources/i/imx-lib/imx-lib-3.14.28-1.0.0/imx-lib-3.14.28-1.0.0.tar.gz
	http://git.yoctoproject.org/cgit/cgit.cgi/meta-fsl-arm/plain/recipes-core/udev/udev-rules-imx/10-imx.rules?id=d9b200205e85727ece1f15f996ce11f4a644d4b8 -> 10-imx.rules
	https://raw.githubusercontent.com/Freescale/meta-fsl-arm/d9b200205e85727ece1f15f996ce11f4a644d4b8/recipes-core/udev/udev-rules-imx/10-imx.rules
	"
LICENSE="LGPL-2.1+"
SLOT="0"

KEYWORDS="~arm"
DEPEND="virtual/udev"

S=${WORKDIR}/${P}-1.0.0

src_compile() {
	emake PLATFORM=IMX6Q pxp
	emake PLATFORM=IMX6Q ipu
}

src_install() {
	emake -C pxp DEST_DIR="${D}" install
	emake -C ipu DEST_DIR="${D}" install
	udev_dorules "${DISTDIR}/10-imx.rules"
}
