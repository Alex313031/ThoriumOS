# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sound Open Firmware (SOF) binary files"

HOMEPAGE="https://www.sofproject.org https://github.com/thesofproject/sof https://github.com/thesofproject/sof-bin"
SRC_URI="https://github.com/thesofproject/sof-bin/archive/stable-v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* amd64"
IUSE=""

S=${WORKDIR}/sof-bin-stable-v${PV}

src_compile() {
	sed -i -e '1i #!/bin/bash\nset -e' go.sh || die
}

src_install() {
	mkdir -p "${D}/lib/firmware/intel" || die
	SOF_VERSION="v${PV}" ROOT="${D}" "${S}/go.sh" || die

	# b/194177834: remove broken symlink (this can be dropped after v1.6.1)
	rm "${D}/lib/firmware/intel/sof/sof-jsl.ri"

	# Add support for ADL, ADL-N, RPL
	dosym ./sof-tgl.ri /lib/firmware/intel/sof/sof-adl.ri
	dosym ./sof-tgl.ri /lib/firmware/intel/sof/sof-adl-n.ri
	dosym ./sof-tgl.ri /lib/firmware/intel/sof/sof-rpl.ri
}
