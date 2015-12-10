# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="Freescale alsa-lib plugins"
HOMEPAGE="https://freescale.github.io"
SRC_URI="http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/${P}.tar.gz
		http://git.yoctoproject.org/cgit/cgit.cgi/meta-fsl-arm/plain/recipes-multimedia/alsa/${PN}/0001-asrc_pair-update-output-buffer-size.patch?id=ddd2feebff74d0fff7ebaca4089d524e4c31ce5c -> 0001-asrc_pair-update-output-buffer-size.patch"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~arm"

DEPEND="media-libs/alsa-lib"
RDEPEND="${DEPEND}"

src_prepare()
{
	epatch "${DISTDIR}/0001-asrc_pair-update-output-buffer-size.patch"
}
