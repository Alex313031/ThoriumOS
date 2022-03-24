# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils linux-info linux-mod git-r3 

DESCRIPTION="Driver for Realtek RTL8821CE Wireless Adapter"
HOMEPAGE="https://github.com/arnoldthebat/rtl8821ce"

# CROS_WORKON_REPO="https://github.com/arnoldthebat"
# CROS_WORKON_PROJECT="rtl8821ce"
# CROS_WORKON_EGIT_BRANCH="srctreetest"
EGIT_REPO_URI="https://github.com/arnoldthebat/rtl8821ce.git"
EGIT_BRANCH="master"
# CROS_WORKON_BLACKLIST="1"
# CROS_WORKON_COMMIT="7c25ec033263b552d17bc4c40940f8318d8cade6"

# This must be inherited *after* EGIT/CROS_WORKON variables defined.
# inherit git-3 # cros-workon #cros-kernel2 cros-workon


LICENSE="GPL-2"
KEYWORDS="-* amd64 x86"

RESTRICT="mirror"

DEPEND="virtual/linux-sources"
RDEPEND=""

S="${WORKDIR}/rtl8821ce-${PV}"
BUILD_TARGETS="modules"
KERNEL_DIR="/mnt/host/source/chroot/build/${BOARD}/var/cache/portage/sys-kernel/chromeos-kernel-4_14"
BUILD_PARAMS="-C ${KERNEL_DIR} M=${S}"

MODULE_NAMES="8821ce(kernel/drivers/net/wireless/:${S})"

pkg_setup() {
    linux-mod_pkg_setup
}

src_compile(){
    linux-mod_src_compile
}

src_install() {
    linux-mod_src_install
    dodoc "${S}/LICENSE"
}