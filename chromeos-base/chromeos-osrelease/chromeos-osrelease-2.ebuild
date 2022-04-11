# Copyright 2022 The Chromium OS Authors and Alex313031. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit osreleased

DESCRIPTION="OS Release Information for ThoriumOS."

LICENSE="BSD-Google ThoriumOS-LICENSE"
SLOT="0"
KEYWORDS="*"
IUSE=""
S="${WORKDIR}"

src_install() {
	do_osrelease_field "NAME" "Thorium OS"
	do_osrelease_field "ID" "thoriumos"
	do_osrelease_field "ID_LIKE" "chromiumos"
	do_osrelease_field "BUG_REPORT_URL" "https://github.com/Alex313031/ChromiumOS/issues/"
	do_osrelease_field "HOME_URL" "https://github.com/Alex313031/ChromiumOS/"
}
