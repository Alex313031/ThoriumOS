# Copyright 2022 The Chromium OS Authors and Alex313031. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="TrImLy fstrim and e4defrag automator script for CrOS and screenfetch-dev by https://github.com/KittyKatt/"

LICENSE="TrImLy_LICENSE"
SLOT="0"
KEYWORDS="*"
IUSE=""
S="${WORKDIR}"

RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	exeinto /usr/local/bin/
	doexe -r "${FILESDIR}"/bin/*
}
