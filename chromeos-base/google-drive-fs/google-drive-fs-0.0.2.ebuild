# Copyright (c) 2022 The Fyde Innovations and Alex313031. All rights reserved.
# Distributed under the license specified in the root directory of this project.

EAPI="5"

DESCRIPTION="Google drive related files"
HOMEPAGE="https://drive.google.com/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}"
S=${WORKDIR}

src_install() {
  exeinto /opt/google/drive-file-stream
  doexe ${FILESDIR}/*
}
