# Copyright 2024 The ChromiumOS Authors and Alex313031
# Distributed under the license specified in the root directory of this project.

EAPI="7"

inherit platform user

DESCRIPTION="Installs easy_unlock binaries for the easy-unlock service."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/easy-unlock/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="
	chromeos-base/cros-disks
	chromeos-base/system_api:=
"

DEPEND="${RDEPEND}"

src_install() {
  exeinto /opt/google/easy_unlock
  doexe ${FILESDIR}/*
}
