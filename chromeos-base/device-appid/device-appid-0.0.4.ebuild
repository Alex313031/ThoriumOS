# Copyright 2024 Fyde Innovations Limited, the openFyde Authors, and Alex313031.
# Distributed under the license specified in the root directory of this project.

EAPI="7"

inherit appid2 cros-unibuild

DESCRIPTION="Creates an app id for this build and update the lsb-release file"
HOMEPAGE="https://github.com/Alex313031/ThoriumOS/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
S="${WORKDIR}"

RDEPEND=""

DEPEND="${RDEPEND}"

src_install() {
	doappid "{C924E0C4-AF80-4B6B-A6F0-DD75EDBCC37C}" "OTHER" "{6B126386-CC06-4EF1-B648-9A0799301D78}"
}
