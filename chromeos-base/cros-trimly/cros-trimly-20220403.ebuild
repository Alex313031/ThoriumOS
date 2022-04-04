# Copyright (c) 2022 The Chromium OS Authors and Alex313031. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="TrImLy fstrim and e4defrag automator script for CrOS by me, memr script to drop caches by me, and screenfetch-dev by https://github.com/KittyKatt/ and pak for unpacking Chromium *.pak files by https://github.com/myfreeer/."
HOMEPAGE="https://github.com/Alex313031/TrImLy"

LICENSE="TrImLy-LICENSE"
SLOT="0"
KEYWORDS="*"
IUSE=""
S="${WORKDIR}"

RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	exeinto /usr/local/bin/
	doexe "${FILESDIR}"/bin/*
}
