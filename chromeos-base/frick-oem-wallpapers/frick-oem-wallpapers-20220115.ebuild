# Copyright 2022 The Chromium OS Authors and Alex313031. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="OEM Wallpapers for ChromiumOS, using the older default minimalist wallpaper by Carl Kleiner, and a photo taken by Andreas Wocko."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""
S="${WORKDIR}"

RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	insinto /usr/share/chromeos-assets/wallpaper/
	doins -r "${FILESDIR}"/wallpaper/*
}
