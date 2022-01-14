# Copyright (c) 2022 The Chromium OS Authors and Alex313031. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Generic ebuild which satisifies virtual/chromeos-bsp.
This is a direct dependency of virtual/target-chromium-os, but is expected
to be overridden in an overlay for each specialized board.  A typical
non-generic implementation will install any board-specific configuration
files and drivers which are not suitable for inclusion in a generic board
overlay."
HOMEPAGE="http://src.chromium.org"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!chromeos-base/chromeos-bsp-null
	chromeos-base/frick-oem-wallpapers
	chromeos-base/cros-trimly
	sys-kernel/linux-firmware
	media-libs/x264
	media-libs/cros-camera-hal-usb
	app-misc/sl
	sys-apps/iotools
	app-admin/sysstat
	sys-process/htop
	sys-process/iotop
	chromeos-base/google-drive-fs
"
DEPEND="${RDEPEND}"


	# !net-wireless/rtl8188eu
	# !net-wireless/rtl8723au
	# !net-wireless/rtl8723bu
	# !net-wireless/rtl8812au
	# !net-wireless/rtl8821ce
