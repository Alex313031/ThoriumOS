EAPI=5

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
	# Install upstart service
  exeinto "/usr/sbin"
  doexe ${FILESDIR}/expand-partition.sh	
	insinto "/etc/init"
	doins ${FILESDIR}/auto-expand-partition.conf
}
