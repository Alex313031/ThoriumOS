# Copyright 2024 The ChromiumOS Authors and Alex313031.
# Distributed under the terms of the GNU General Public License v3

EAPI="7"

DESCRIPTION="Simple cmdline Pi calculator."
HOMEPAGE="https://github.com/Alex313031/ThoriumOS/tree/main/wallpapers"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
S="${WORKDIR}"

RDEPEND="${RDEPEND}"

src_install() {
	dobin "${FILESDIR}"/pi
}
