# Copyright 2022 The Chromium OS Authors and Alex313031. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Empty package for libdiagcfg"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86 arm64 arm"
IUSE="diag"
S="${WORKDIR}"

DEPEND="${RDEPEND}"

src_install() {
	if use diag; then
	insinto /etc
	doins "${FILESDIR}"/etc/libdiagcfg
	fi
}
