# Copyright (c) 2023 Fyde Innovations Limited, the openFyde Authors, and Alex313031.
# Distributed under the license specified in the root directory of this project.

EAPI="7"

DESCRIPTION="Rules for switching between VGA output"
HOMEPAGE="http://fydeos.com"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}"

S=${WORKDIR}

src_install() {
  insinto /lib/udev/rules.d
  doins ${FILESDIR}/99-vga-switch.rules
  exeinto /lib/udev
  doexe ${FILESDIR}/vga-switch.sh
}
