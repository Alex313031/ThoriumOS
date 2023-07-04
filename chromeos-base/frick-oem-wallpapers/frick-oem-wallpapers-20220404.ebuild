# Copyright 2023 The Chromium OS Authors and Alex313031. All rights reserved.
# Distributed under the terms of the GNU General Public License v3

EAPI="7"

DESCRIPTION="OEM Wallpapers for ChromiumOS, using a wallpaper by Carl Kleiner, and a photo taken by Andreas Wocko."
HOMEPAGE="https://github.com/Alex313031/ThoriumOS/tree/main/wallpapers"

LICENSE="frick-oem-wallpapers-LICENSE"
SLOT="0"
KEYWORDS="*"
IUSE="frick-wallpapers"
S="${WORKDIR}"

RDEPEND="chromeos-base/common-assets"
DEPEND="${RDEPEND}"

src_install() {
	if use frick-wallpapers; then
	insinto /usr/share/chromeos-assets/wallpaper/
	doins -r "${FILESDIR}"/wallpaper/*
	fi
}
