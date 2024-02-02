# Copyright (c) 2024 Fyde Innovations Limited, the openFyde Authors, and Alex313031.
# Distributed under the license specified in the root directory of this project.

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

EGIT_REPO_URI="https://github.com/onitake/gsl-firmware.git"
#EGIT_BRANCH="master"
#EGIT_HAS_SUBMODULES="true"
#EGIT_NONBARE="true"
#EGIT_COMMIT="9bb83d06904151b98c1faa1d7540497e17195993"

inherit git-r3
DESCRIPTION="Firmware for silead mmsl1680 touchscreen"
HOMEPAGE="https://github.com/onitake/gsl-firmware"

SRC_URI=""
LICENSE="GPL-3"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="mirror binchecks strip"
SLOT="0"

DEPEND=""
RDEPEND=""

src_install() {
	insinto /lib/firmware
#	doins firmware/cube/i1101/silead_ts.fw || die
	doins -r firmware/linux/silead 
}
