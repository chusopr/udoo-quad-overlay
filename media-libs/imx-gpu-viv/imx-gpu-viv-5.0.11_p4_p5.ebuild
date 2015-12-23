# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs

if [ "$(tc-is-softfloat)" == "no" ]
then
	fp=hfp
else
	fp=sfp
fi

MY_PV="5.0.11.p4.5-$fp"
DESCRIPTION="Binary vivante gpu files"
HOMEPAGE="https://freescale.github.io"

SRC_URI="http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/${PN}-${MY_PV}.bin"

LICENSE="Freescale-3rd_party"

SLOT="0"

KEYWORDS="~arm"

DEPEND="app-eselect/eselect-opengl
	app-eselect/eselect-vivante
	sys-kernel/firmware-imx
	x11-libs/libX11
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libXext
	x11-libs/libxcb
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libdrm"

S="${WORKDIR}/${PN}-${MY_PV}"
OPENGLDIR=usr/lib/opengl/vivante

src_unpack() {
	sh "${DISTDIR}/${A}" --force --auto-accept || die
}

src_compile(){
	cd gpu-core/usr/lib &&
	# Duplicated
	rm libVIVANTE.fb.so &&
	# x11 implementation of GAL_egl is called "dri" implementation
	mv libGAL_egl.dri.so libGAL_egl.x11.so &&
	# Remove already linked libraries to let app-eselect/eselect-vivante do the choice
	rm -f libEGL.so &&
	ln -sf libEGL.so libEGL.so.1.0 &&
	ln -sf libEGL.so libEGL.so.1 &&
	rm -f libGAL.so &&
	rm -f libGLESv2.so &&
	ln -sf libGLESv2.so libGLESv2.so.2.0.0 &&
	ln -sf libGLESv2.so libGLESv2.so.2 &&
	rm -f libVIVANTE.so &&
	ln -sf libGL.so.1.2 libGL.so.1 &&
	ln -sf libGL.so.1.2 libGL.so &&
	ln -sf libOpenVG.3d.so libOpenVG.so &&
	cd pkgconfig &&
	mv egl_directfb.pc egl_dfb.pc &&
	mv egl_linuxfb.pc egl_fb.pc &&
	mv egl_wayland.pc egl_wl.pc &&
	rm egl.pc &&
	cp glesv1_cm.pc glesv1_cm_dfb.pc &&
	cp glesv1_cm.pc glesv1_cm_fb.pc &&
	mv glesv1_cm.pc glesv1_cm_wl.pc &&
	cp glesv2.pc glesv2_dfb.pc &&
	cp glesv2.pc glesv2_fb.pc &&
	mv glesv2.pc glesv2_wl.pc &&
	cp vg.pc vg_dfb.pc &&
	cp vg.pc vg_fb.pc &&
	mv vg.pc vg_wl.pc &&
	sed -i "s/(LINUX)/(linux)/g" ../../include/EGL/* ../../include/HAL/* || die
}

src_install(){
	dodir ${OPENGLDIR}/lib ${OPENGLDIR}/include /usr/include /etc
	mv gpu-core/usr/lib/dri "$D/usr/lib" &&
	mv gpu-core/usr/lib/pkgconfig "$D/usr/lib" &&
	mv gpu-core/usr/lib/directfb* "$D/usr/lib" &&
	mv gpu-core/usr/lib/lib{CLC,GAL,OpenCL,VDK,VivanteOpenCL,VIVANTE,VSC,*wayland}* "$D/usr/lib" &&
	mv gpu-core/usr/lib/* "$D/${OPENGLDIR}/lib" &&
	mv gpu-core/usr/include/{CL,HAL,gc_*,vdk.h} "$D/usr/include" &&
	mv gpu-core/usr/include/* "$D/${OPENGLDIR}/include" &&
	mv g2d/usr/include/* "$D/usr/include" &&
	mv g2d/usr/lib/* "$D/usr/lib" &&
	mv gpu-core/etc/* "${D}/etc" &&
	dobin gpu-tools/gmem-info/usr/bin/gmem_info || die
}

pkg_postinst(){
	einfo "Please ignore previous errors about missing soname symlinks"
	eselect opengl set vivante
	eselect --brief vivante show | fgrep -q unset || {
		ewarn "Please choose your Vivante implementation as soon as possible."
		ewarn "Packages depending on this one may not build correctly until you do that."
	}
}
