# Copyright 1999-2016 Gentoo Foundation
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

IUSE="X directfb wayland"

DEPEND="app-eselect/eselect-opengl
	app-eselect/eselect-vivante
	sys-devel/gcc
	sys-kernel/firmware-imx
	x11-libs/libX11
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libXext
	X? ( x11-libs/libdrm )
	directfb? ( =dev-libs/DirectFB-1.7.4 )
	wayland? (
		dev-libs/libffi
		dev-libs/wayland
	)"

S="${WORKDIR}/${PN}-${MY_PV}"
OPENGLDIR=usr/lib/opengl/vivante

src_unpack() {
	sh "${DISTDIR}/${A}" --force --auto-accept || die
}

src_compile(){
	cd gpu-core/usr/lib || die
	if use directfb; then
		mv pkgconfig/egl_directfb.pc pkgconfig/egl_dfb.pc &&
		cp pkgconfig/glesv1_cm.pc pkgconfig/glesv1_cm_dfb.pc &&
		cp pkgconfig/glesv2.pc pkgconfig/glesv2_dfb.pc &&
		cp pkgconfig/vg.pc pkgconfig/vg_dfb.pc || die
	else
		rm -r ../../etc/directfbrc *directfb* pkgconfig/egl_directfb.pc *dfb*
	fi
	if use wayland; then
		mv pkgconfig/egl_wayland.pc pkgconfig/egl_wl.pc &&
		cp pkgconfig/glesv1_cm.pc pkgconfig/glesv1_cm_wl.pc &&
		cp pkgconfig/glesv2.pc pkgconfig/glesv2_wl.pc &&
		cp pkgconfig/vg.pc pkgconfig/vg_wl.pc || die
	else
		rm -r *wayland* *wl* pkgconfig/*wayland* ../include/wayland-viv
	fi
	if use X; then
		# x11 implementation of GAL_egl is called "dri" implementation
		mv libGAL_egl.dri.so libGAL_egl.x11.so || die
	else
		rm -r libGAL_egl.dri.so *x11* dri pkgconfig/*x11*
	fi
	# Duplicated
	rm libVIVANTE.fb.so &&
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
	mv egl_linuxfb.pc egl_fb.pc &&
	rm egl.pc &&
	mv glesv1_cm.pc glesv1_cm_fb.pc &&
	mv glesv2.pc glesv2_fb.pc &&
	mv vg.pc vg_fb.pc || die
}

src_install(){
	dodir ${OPENGLDIR}/lib ${OPENGLDIR}/include /usr/include /etc
	if use directfb; then
		mv gpu-core/usr/lib/directfb* "$D/usr/lib" || die
	fi
	if use wayland; then
		mv gpu-core/usr/lib/lib*wayland* "$D/usr/lib" || die
	fi
	if use X; then
		mv gpu-core/usr/lib/dri "$D/usr/lib" || die
	fi
	mv gpu-core/usr/lib/pkgconfig "$D/usr/lib" &&
	mv gpu-core/usr/lib/lib{CLC,GAL,OpenCL,VDK,VivanteOpenCL,VIVANTE,VSC}* "$D/usr/lib" &&
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
	if ! use directfb && ! use wayland && ! use X; then
		eselect vivante set fb
		eselect opengl set vivante
	else
		eselect --brief vivante show | fgrep -q unset && {
			ewarn "Please choose your Vivante implementation using 'eselect vivante' as soon as possible."
			ewarn "Packages depending on this one may not build correctly until you do that."
		}
	fi
}
