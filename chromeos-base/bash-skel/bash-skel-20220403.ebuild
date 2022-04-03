# Copyright (c) 2022 Alex313031. All rights reserved.
# Distributed under the terms of the GNU General Public License v3

EAPI="5"
inherit chrome-dev-flags 
DESCRIPTION="Appends aliases to the .bashrc that is copied from /etc/skel/ to all users home dirs."
HOMEPAGE="https://github.com/Alex313031/ChromiumOS/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE="chrome-dev-flags"
S="${WORKDIR}"

RDEPEND="app-shells/bash"
DEPEND="${RDEPEND}"

src_install() {
	if use chrome-dev-flags; then
	insinto /etc/skel
	doins "${FILESDIR}"/etc/skel/.bashrc
	fi
}
