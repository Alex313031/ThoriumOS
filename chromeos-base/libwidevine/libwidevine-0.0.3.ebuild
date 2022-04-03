# Copyright (c) 2022 The Fyde Innovations and Alex313031. All rights reserved.
# Distributed under the license specified in the root directory of this project.

EAPI="5"

DESCRIPTION="Setup Widevine DRM"
HOMEPAGE="https://www.widevine.com/solutions/widevine-drm"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="widevine"

RDEPEND="chromeos-base/chromeos-chrome"
DEPEND="${RDEPEND}"

CHROMIUM_DIR=/opt/google/chrome/

S=${WORKDIR}

src_install() {
  if use widevine; then
  exeinto ${CHROMIUM_DIR}
  doexe "${FILESDIR}"/*
  fi
}
