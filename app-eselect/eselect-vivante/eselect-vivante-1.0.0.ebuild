# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Manages Vivante OpenGL implementations"
HOMEPAGE="https://github.com/chusopr/udoo-overlay"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm"

RDEPEND=">=app-admin/eselect-1.0.6
	>=app-shells/bash-4
	sys-apps/coreutils
	sys-apps/grep
	sys-apps/sed"

S=${WORKDIR}
src_install() {
	insinto /usr/share/eselect/modules
	newins "${FILESDIR}/${P/eselect-/}.eselect" "${PN/eselect-/}.eselect"
}
