# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="Freescale HE-AAC library"
HOMEPAGE="https://freescale.github.com"
SRC_URI="http://repository.timesys.com/buildsources/l/${PN}/${P}/${P}.bin
		http://repository.timesys.com/buildsources/l/${PN}/${P}/${P}-fix-library-path.patch"

# need to get user to accept the license ? .. where does the license go?
LICENSE="Freescale-3rd_party"
SLOT="0"

KEYWORDS="~arm"
IUSE="doc examples"
DEPEND="media-libs/libfslcodec"
RDEPEND="${DEPEND}"

src_unpack() {
	sh "${DISTDIR}/${P}.bin" --force --auto-accept || die
}

src_prepare() {
	epatch "${DISTDIR}"/libfslaacpcodec-4.0.3-fix-library-path.patch
}

src_install() {
	einstall
	use doc || rm -fr "${D}/usr/share/doc"
	use examples || rm -fr "${D}/usr/share/imx-mm"
}
