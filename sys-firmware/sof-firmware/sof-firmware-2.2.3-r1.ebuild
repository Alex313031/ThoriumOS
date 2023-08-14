# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Sound Open Firmware (SOF) binary files"

HOMEPAGE="https://www.sofproject.org https://github.com/thesofproject/sof https://github.com/thesofproject/sof-bin"
SRC_URI="https://github.com/thesofproject/sof-bin/releases/download/v${PV}/sof-bin-v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* amd64"
IUSE=""

S=${WORKDIR}/sof-bin-v${PV}

src_install() {
	dodir /lib/firmware/intel
	dodir /usr/bin
	FW_DEST="${D}/lib/firmware/intel" TOOLS_DEST="${D}/usr/bin" "${S}/install.sh" v${PV} || die
}

pkg_preinst() {
	local sofpath="${EROOT}/lib/firmware/intel/sof"
	if [[ ! -L "${sofpath}" && -d "${sofpath}" ]] ; then
		rm -r "${sofpath}" || die
	fi
}
