# Copyright 2022 The Chromium OS Authors and Alex313031. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit osreleased

DESCRIPTION="OS Release Information"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""
S="${WORKDIR}"

src_install() {
	do_osrelease_field "NAME" "Thorium OS"
}
