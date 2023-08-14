# Copyright 2023 The Fyde Innovations and Alex313031. All rights reserved.
# Distributed under the license specified in the root directory of this project.

EAPI="7"

DESCRIPTION="Auto expand stateful partition on first boot."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="autoexpand"

DEPEND=""
RDEPEND="${DEPEND}
	sys-apps/gptfdisk
"

S=${WORKDIR}

src_install() {
  if use autoexpand; then
	# Install upstart service
  exeinto "/usr/sbin"
  doexe ${FILESDIR}/expand-partition.sh	
	insinto "/etc/init"
	doins ${FILESDIR}/auto-expand-partition.conf
  fi
}
