# Copyright (c) 2023 Alex313031. All rights reserved.
# Distributed under the license specified in the root directory of this project.

EAPI="7"

DESCRIPTION="Install libassistant.so for assistant-dlc"
HOMEPAGE="https://assistant.google.com/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="libassistant"

DEPEND="${RDEPEND}"

CHROMIUM_DIR=/opt/google/chrome/
LIBASSISTANT_DIR=/build/share/libassistant

S=${WORKDIR}

src_install() {
  if use libassistant; then
  exeinto ${CHROMIUM_DIR}
  doexe "${FILESDIR}"/*
  fi
#
#  if use libassistant; then
#  exeinto ${LIBASSISTANT_DIR}
#  doexe "${FILESDIR}"/*
#  fi
#
#  	if use chrome_media; then
#		# Copy LibAssistant v1 and v2 libraries to a temp build folder for later
#		# installation of `assistant-dlc`.
#		exeinto /build/share/libassistant
#		doexe "${FROM}/libassistant.so"
#	fi
}
