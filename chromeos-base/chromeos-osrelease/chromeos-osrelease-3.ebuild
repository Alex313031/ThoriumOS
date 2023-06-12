# Copyright 2023 The Chromium OS Authors and Alex313031. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit osreleased

DESCRIPTION="OS Release Information for ThoriumOS."
HOMEPAGE="https://github.com/Alex313031/ChromiumOS/"

LICENSE="BSD-Google ThoriumOS-LICENSE"
SLOT="0"
KEYWORDS="*"
IUSE="thoriumos"
S="${WORKDIR}"

src_install() {
	if use thoriumos; then
	do_osrelease_field "NAME" "Thorium OS"
	do_osrelease_field "ID" "thoriumos"
	do_osrelease_field "ID_LIKE" "chromiumos"
	do_osrelease_field "BUG_REPORT_URL" "https://github.com/Alex313031/ThoriumOS/issues/"
	do_osrelease_field "HOME_URL" "https://github.com/Alex313031/ThoriumOS/"
	fi
}
