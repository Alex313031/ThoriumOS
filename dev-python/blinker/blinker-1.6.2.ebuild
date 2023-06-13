# Copyright 1999-2023 Gentoo Authors and Alex313031
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 pypi

DESCRIPTION="Fast, simple object-to-object and broadcast signaling"
HOMEPAGE="
	https://github.com/pallets-eco/blinker/
	https://pypi.org/project/blinker/
"

LICENSE="MIT"
SLOT="0"
IUSE="-test +python3_9 +python_targets_python3_9"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest
