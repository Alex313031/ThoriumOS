# Copyright 2024 The Chromium OS Authors and Alex313031. All rights reserved.
# Distributed under the terms of the GNU General Public License v3

EAPI="7"

DESCRIPTION="JPEG XL image format reference implementation"
HOMEPAGE="https://github.com/libjxl/libjxl"
# SRC_URI="https://github.com/libjxl/libjxl/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="JXL_LICENSE"
SLOT="0"
KEYWORDS="amd64"
IUSE="openexr"
S="${WORKDIR}"

DEPEND="openexr? ( media-libs/openexr:= )"
RDEPEND="${DEPEND}"

src_install() {
	exeinto /usr/local/bin/
	doexe "${FILESDIR}"/*
}
