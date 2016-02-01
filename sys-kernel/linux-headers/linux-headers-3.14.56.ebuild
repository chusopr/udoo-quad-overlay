# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

ETYPE="headers"
H_SUPPORTEDARCH="arm"
inherit kernel-2
detect_version

SRC_URI="https://download.chuso.net/distfiles/udoo-headers-${PV}.tar.xz"

KEYWORDS="~arm"

DEPEND="app-arch/xz-utils
	dev-lang/perl"
RDEPEND="!!media-sound/alsa-headers"

S="$WORKDIR"

src_unpack() {
	unpack ${A}
}

src_install() {
	mv usr "${ED}"
	# provided by libdrm (for now?)
	rm -rf "${ED}"/$(kernel_header_destdir)/drm
}

src_test() {
	einfo "Possible unescaped attribute/type usage"
	egrep -r \
		-e '(^|[[:space:](])(asm|volatile|inline)[[:space:](]' \
		-e '\<([us](8|16|32|64))\>' \
		.

	einfo "Missing linux/types.h include"
	egrep -l -r -e '__[us](8|16|32|64)' "${ED}" | xargs grep -L linux/types.h

	emake ARCH=$(tc-arch-kernel) headers_check
}
