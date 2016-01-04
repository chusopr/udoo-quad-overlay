# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs

MY_PV="5.0.11.p4.5"
DESCRIPTION="Vivante xorg driver"
HOMEPAGE="https://freescale.github.io"
SRC_URI="http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/xserver-xorg-video-imx-viv-${MY_PV}.tar.gz
		https://git.yoctoproject.org/cgit/cgit.cgi/meta-fsl-arm/plain/recipes-graphics/xorg-xserver/xserver-xf86-config/mx6/xorg.conf?id=5efa2d7c81a4c1f3590a3e2f8cf77bf2f2d756e9 -> xorg.conf.vivante"

LICENSE="GPL-2+ MIT"

SLOT="0"

KEYWORDS="~arm"

DEPEND="media-libs/imx-gpu-viv
	virtual/pkgconfig
	x11-libs/libdrm"

S=${WORKDIR}/xserver-xorg-video-imx-viv-${MY_PV}

src_compile() {
	hardfp=0
	if [ "$(tc-is-softfloat)" == "no" ]
	then
		hardfp=1
	fi
	emake prefix=/usr BUSID_HAS_NUMBER=1 XSERVER_GREATER_THAN_13=1 BUILD_HARD_VFP=$hardfp CFLAGS="${CFLAGS} $(pkg-config --cflags libdrm)"
}

src_install() {
	einstall prefix="${D}/usr"
	insinto /etc/X11/xorg.conf.d
	newins "${DISTDIR}"/xorg.conf.vivante 10-vivante.conf
	dodir /etc/local.d
	echo "DISPLAY=:0 autohdmi &" > ${D}/etc/local.d/autohdmi.start &&
	chmod 755 "${D}"/etc/local.d/autohdmi.start || die
	insinto /usr/include
	doins EXA/src/vivante_gal/vivante_priv.h EXA/src/vivante_gal/vivante_gal.h
}

pkg_postinst(){
	eselect opengl set vivante
}
