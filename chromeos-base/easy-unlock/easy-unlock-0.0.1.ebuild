# Copyright 2024 Alex313031. All rights reserved.
# Distributed under the license specified in the root directory of this project.

EAPI="7"

DESCRIPTION="Installs easy_unlock related files."
HOMEPAGE="https://drive.google.com/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="amd64"
IUSE="drivefs"

RDEPEND="chromeos-base/cros-disks"

DEPEND="${RDEPEND}"
S=${WORKDIR}

src_install() {
  if use drivefs; then
  exeinto /opt/google/easy_unlock
  doexe ${FILESDIR}/*
  fi
}
