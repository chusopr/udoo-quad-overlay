# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
K_SECURITY_UNSUPPORTED="1"
K_DEBLOB_AVAILABLE="1"
ETYPE="sources"
EGIT_REPO_URI="https://github.com/UDOOboard/linux_kernel"
EGIT_COMMIT="39d84fc8d22f3ae731d8ebf95776af9ab3b07eab"
EGIT_CHECKOUT_DIR=${WORKDIR}/linux-${PV}-udoo
inherit kernel-2 git-r3
detect_version

DESCRIPTION="Full sources for the Linux kernel with Udoo board support"
HOMEPAGE="https://github.com/UDOOboard/linux_kernel"

KEYWORDS="~arm"
IUSE="deblob"

S=$EGIT_CHECKOUT_DIR
