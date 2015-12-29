# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="https://github.com/laanwj/etna_viv"
inherit eutils git-r3

DESCRIPTION="FOSS user-space driver for the Vivante GCxxx series of embedded GPUs"
HOMEPAGE="https://github.com/etnaviv/libetnaviv"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm"

DEPEND="sys-kernel/udoo-sources"

S="${WORKDIR}/${P}/src/etnaviv"

src_prepare() {
	sed -i -r \
		-e "s/-O[0-9]+//g" \
		-e "s/-g[^ ]*[0-9]+//g" \
		../Makefile.inc || die
}

src_compile() {
	GCABI="imx6_v4_6_9" emake
}

src_install() {
	dolib.a "${PN}.a"
	insinto /usr/include/etnaviv
	doins *.h
	dodoc README.md
}
