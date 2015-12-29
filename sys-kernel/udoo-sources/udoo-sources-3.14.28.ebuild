# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
K_SECURITY_UNSUPPORTED="1"
K_DEBLOB_AVAILABLE="1"
ETYPE="sources"
EGIT_REPO_URI="https://github.com/UDOOboard/linux_kernel"
EGIT_COMMIT="e62d8106bd22db78b7365bf6558aafd6b902d084"
EGIT_CHECKOUT_DIR=${WORKDIR}/linux-${PV}-udoo
inherit kernel-2 git-r3
detect_version

DESCRIPTION="Full sources for the Linux kernel"
HOMEPAGE="http://www.kernel.org"

KEYWORDS="~arm"
IUSE="deblob"

S=$EGIT_CHECKOUT_DIR
