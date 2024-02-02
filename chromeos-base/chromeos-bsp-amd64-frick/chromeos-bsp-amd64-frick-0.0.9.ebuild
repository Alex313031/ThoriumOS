# Copyright 2024 The Chromium OS Authors and Alex313031. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cros-unibuild udev

DESCRIPTION="Creates an app id for this build and updates the lsb-release file."
HOMEPAGE="https://github.com/Alex313031/ThoriumOS/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
S="${WORKDIR}"

# TODO(b/321687359), remove once root issue is resolved.
# DEPEND="sys-apps/busybox"
# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	!<chromeos-base/gestures-conf-0.0.2
	chromeos-base/chromeos-config
	chromeos-base/device-appid
	chromeos-base/flex_bluetooth
	chromeos-base/flex_hwis
	chromeos-base/reven-hwdb
	chromeos-base/reven-quirks
	sys-firmware/fwupd-uefi-dbx
"

src_install() {

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Touchpad config files
	insinto "/etc/gesture"
	doins "${FILESDIR}"/gesture/*
}
