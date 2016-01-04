# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_4 )

if use imx6; then
	EGIT_REPO_URI="git://github.com/zpon/libcec-imx6"
	EGIT_COMMIT="7ca2d55553e792e418200853f389043c769c2985"
	GIT_ECLASS="git-r3"
fi

inherit cmake-utils eutils linux-info python-single-r1 ${GIT_ECLASS}
DESCRIPTION="Library for communicating with the Pulse-Eight USB HDMI-CEC Adaptor"
HOMEPAGE="http://libcec.pulse-eight.com"

if ! use imx6; then
	SRC_URI="https://github.com/Pulse-Eight/${PN}/archive/${P}.tar.gz"
fi

LICENSE="GPL-2+"

SLOT="0"

IUSE="cubox exynos python raspberry-pi imx6 +xrandr"
KEYWORDS="~arm"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="virtual/udev
	dev-libs/lockdev
	dev-libs/libplatform
	xrandr? ( x11-libs/libXrandr )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	python? (
		dev-lang/swig
		${PYTHON_DEPS}
	)"

CONFIG_CHECK="~USB_ACM"

if ! use imx6; then
	S="${WORKDIR}/${PN}-${P}"
	PATCHES=( "${FILESDIR}"/${P}-envcheck.patch )
fi

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare
	use python || comment_add_subdirectory "src/pyCecClient"
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_useno python SKIP_PYTHON_WRAPPER)
		$(cmake-utils_use_has exynos EXYNOS_API) \
		$(cmake-utils_use_has cubox TDA955X_API)
		$(cmake-utils_use_has raspberry-pi RPI_API)
		$(cmake-utils_use_has imx6 IMX6_API)
	)
	cmake-utils_src_configure
}
