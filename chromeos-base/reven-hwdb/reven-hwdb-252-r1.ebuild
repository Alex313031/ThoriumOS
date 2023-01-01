# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit udev

SRC_URI="https://github.com/systemd/systemd/archive/v${PV}.tar.gz -> systemd-${PV}.tar.gz"
KEYWORDS="*"

DESCRIPTION="Use the hardware DB from the systemd repo for the reven board"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/systemd"

LICENSE="LGPL-2.1"
SLOT="0"

S=${WORKDIR}/systemd-stable-${PV}

PATCHES=(
	"${FILESDIR}"/systemd-252-remove-unwanted-entries.patch
)

# Add empty src_configure() and src_compile() so we can bypass these phases
src_configure() { :; }
src_compile() { :; }

src_install() {
	# The keyboard hwdb file supports a wide range of models can be uprevved through this package
	# Renaming 60-keyboard.hwdb to 66-reven-keyboard.hwdb to take precedence over the hwids hwdb(to be deprecated)
	insinto "$(get_udevdir)/hwdb.d"
	newins "${S}/hwdb.d/60-keyboard.hwdb" "66-reven-keyboard.hwdb"
	# udev's hwdb.bin needs to be generated after the files are put in "$(get_udevdir)/hwdb.d"
	# this package relies on build_image which regenerates the hwdb.bin file
}
