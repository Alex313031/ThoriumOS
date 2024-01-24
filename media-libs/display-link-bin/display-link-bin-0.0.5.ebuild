# Copyright (c) 2024 Fyde Innovations Limited, the openFyde Authors, and Alex313031.
# Distributed under the license specified in the root directory of this project.

EAPI="7"

inherit user

DESCRIPTION="Binary files for display link driver"
HOMEPAGE="https://www.synaptics.com/products/displaylink-graphics"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
  media-libs/evdi
  dev-libs/libusb
"

DEPEND="${RDEPEND}"

S=$FILESDIR

pkg_preinst() {
  enewuser dlm
  enewgroup dlm
}

src_install() {
  insinto /etc/init
  doins ${FILESDIR}/displaylink-driver.conf

  insinto /lib/udev/rules.d
  doins ${FILESDIR}/90-smiusbdisplay.rules

  exeinto /opt/displaylink
  doexe ${FILESDIR}/displaylink/*

  exeinto /opt/siliconmotion
  doexe ${FILESDIR}/siliconmotion/*
}
