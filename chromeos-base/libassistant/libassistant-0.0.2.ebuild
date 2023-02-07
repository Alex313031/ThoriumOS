# Copyright (c) 2023 Alex313031. All rights reserved.
# Distributed under the license specified in the root directory of this project.

EAPI="7"

DESCRIPTION="Install libassistant.so for assistant-dlc"
HOMEPAGE="https://www.widevine.com/solutions/widevine-drm"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="libassistant"

DEPEND="${RDEPEND}"

CHROMIUM_DIR=/opt/google/chrome/

S=${WORKDIR}

src_install() {
  if use libassistant; then
  exeinto ${CHROMIUM_DIR}
  doexe "${FILESDIR}"/*
  fi
}
