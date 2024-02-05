# Copyright 1999-2024 Gentoo Authors and Alex313031
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools toolchain-funcs

DESCRIPTION="Find duplicate files based on their content"
HOMEPAGE="https://github.com/pauldreik/rdfind"
SRC_URI="https://rdfind.pauldreik.se/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="dev-libs/nettle:="
DEPEND="${RDEPEND}"
BDEPEND="dev-build/autoconf-archive"

src_configure() {
	cros_allow_gnu_build_tools
}

src_prepare() {
	default
	eautoreconf
}

src_test() {
	# Bug 840544
	local -x SANDBOX_PREDICT="${SANDBOX_PREDICT}"
	addpredict /
	default
}
