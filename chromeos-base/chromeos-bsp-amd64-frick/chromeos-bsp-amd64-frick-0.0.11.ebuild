# Copyright 2024 The Chromium OS Authors and Alex313031. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cros-unibuild udev

DESCRIPTION="Creates an app id for this build and updates the lsb-release file."
HOMEPAGE="https://github.com/Alex313031/ThoriumOS/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay

# TODO(b/321687359), remove once root issue is resolved.
DEPEND="sys-apps/busybox"
RDEPEND="
	!<chromeos-base/gestures-conf-0.0.2
	!<chromeos-base/chromeos-bsp-reven-private-0.0.1-r20
	chromeos-base/chromeos-config
	chromeos-base/device-appid
	chromeos-base/flex_bluetooth
	chromeos-base/flex_hwis
	chromeos-base/reven-hwdb
	chromeos-base/reven-quirks
	sys-firmware/fwupd-uefi-dbx
"

# Normally the libinput dep is added by chromeos-chrome with the
# libinput USE flag, but sometimes with local builds the chromeos-chrome
# package ends up being the amd64-generic package, which doesn't have
# that USE flag enabled. In that case, libinput doesn't end up in the
# image. If you then use the Simple Chrome Workflow to deploy a proper
# reven browser, it will fail to start due to the missing libinput
# library. Adding this explicit dep ensures that the image always has
# libinput available.
RDEPEND="${RDEPEND} dev-libs/libinput"

src_install() {

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Touchpad config files
	insinto "/etc/gesture"
	doins "${FILESDIR}"/gesture/*
}
