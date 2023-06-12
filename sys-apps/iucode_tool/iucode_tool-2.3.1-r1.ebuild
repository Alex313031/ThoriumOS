# Copyright 1999-2023 Gentoo Authors and Alex313031
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tool to manipulate Intel x86 and x86-64 processor microcode update collections"
HOMEPAGE="https://gitlab.com/iucode-tool/"
SRC_URI="https://gitlab.com/iucode-tool/releases/raw/master/${PN/_/-}_${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

S="${WORKDIR}/${PN/_/-}-${PV}"
