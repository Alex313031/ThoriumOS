# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils linux-info linux-mod

DESCRIPTION="rtl8812AU_8821AU linux kernel driver for AC1200 (801.11ac) Wireless Dual-Band USB Adapter"
HOMEPAGE="https://github.com/arnoldthebat/rtl8812AU_8821AU_linux"

CROS_WORKON_REPO="https://github.com/arnoldthebat"
CROS_WORKON_PROJECT="rtl8812AU_8821AU_linux"
CROS_WORKON_EGIT_BRANCH="master"
CROS_WORKON_MANUAL_UPREV="1"
CROS_WORKON_COMMIT="bed205c14a363fedd8b3a497ef0141588b610d50"

# This must be inherited *after* EGIT/CROS_WORKON variables defined.
inherit git-2 cros-workon #cros-kernel2 cros-workon


LICENSE="GPL-2"
KEYWORDS="-* amd64 x86"

RESTRICT="mirror"

DEPEND="virtual/linux-sources"
RDEPEND=""

MODULE_NAMES="rtl8812au(kernel/drivers/net/wireless/realtek/rtlwifi/rtl8812au)"

pkg_setup() {

	linux-mod_pkg_setup

	BUILD_PARAMS="-C /mnt/host/source/chroot/build/${BOARD}/var/cache/portage/sys-kernel/chromeos-kernel-4_14 M=${S}"
	BUILD_TARGETS="rtl8812au.ko"
}


src_install() {
	linux-mod_src_install

	dodoc "${S}/LICENSE"
}
