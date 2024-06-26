# Copyright 2024 The ChromiumOS Authors and Alex313031.
# Distributed under the terms of the GNU General Public License v3

EAPI="7"

inherit user

DESCRIPTION="OEM pre-installed Extensions/Chrome Apps for ThoriumOS."
HOMEPAGE="https://github.com/Alex313031/ThoriumOS/tree/main/wallpapers"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
S=$FILESDIR

RDEPEND="chromeos-base/common-assets"
DEPEND="${RDEPEND}"

src_install() {
	# mkdir -p -v /mnt/stateful_partition/unencrypted/import_extensions

	insinto /mnt/stateful_partition/unencrypted/import_extensions/
	doins -r "${FILESDIR}"/crx/*
}
