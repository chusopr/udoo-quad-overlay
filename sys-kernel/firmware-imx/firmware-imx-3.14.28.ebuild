# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="Freescale IMX firmware such as for the VPU"
HOMEPAGE="https://freescale.github.io"
SRC_URI="http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/${P}-1.0.0.bin
		https://community.freescale.com/servlet/JiveServlet/download/335225-262426/v4l-codadx6-imx27.bin.zip
		https://s.chuso.net/chuso-overlay/distfiles/fslbsp2coda.c"

LICENSE="Freescale"
SLOT="0"
KEYWORDS="~arm"

S=${WORKDIR}/${P}-1.0.0

src_unpack() {
	sh "${DISTDIR}/${P}-1.0.0.bin" --force --auto-accept || die
	unpack v4l-codadx6-imx27.bin.zip
}

src_compile() {
	gcc -o fslbsp2coda "${DISTDIR}/fslbsp2coda.c" &&
	./fslbsp2coda firmware/vpu/vpu_fw_imx53.bin firmware/vpu/v4l-coda7541-imx53.bin &&
	./fslbsp2coda firmware/vpu/vpu_fw_imx6d.bin firmware/vpu/v4l-coda960-imx6dl.bin &&
	./fslbsp2coda firmware/vpu/vpu_fw_imx6q.bin firmware/vpu/v4l-coda960-imx6q.bin ||
	die
}

src_install(){
	rm firmware/Android.mk &&
	mv ../v4l-codadx6-imx27.bin firmware/vpu &&
	(cd firmware && ln -s vpu/v4l-coda* .) &&
	dodir /lib &&
	mv firmware "$D/lib" || die
}
