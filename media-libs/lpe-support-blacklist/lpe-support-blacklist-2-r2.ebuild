# Copyright (c) 2024 Fyde Innovations Limited, the openFyde Authors, and Alex313031.
# Distributed under the license specified in the root directory of this project.

EAPI="7"

DESCRIPTION="Files used to support/configure LPE Audio"
LICENSE="BSD-Intel"
SLOT="0"

KEYWORDS="*"

S=${WORKDIR}

src_install() {
	insinto /etc/modprobe.d
	doins "${FILESDIR}"/alsa-skl.conf

}
