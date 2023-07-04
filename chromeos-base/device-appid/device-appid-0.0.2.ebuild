# Copyright 2023 Fyde Innovations Limited and the openFyde Authors and Alex313031.
# Distributed under the license specified in the root directory of this project.

EAPI="5"

inherit appid cros-unibuild

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
	doappid "{C924E0C4-AF80-4B6B-A6F0-DD75EDBCC37C}" "OTHER"
}
