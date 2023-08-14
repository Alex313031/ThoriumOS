# Copyright 2023 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This ebuild only cares about its own FILESDIR and ebuild file, so it tracks
# the canonical empty project.
CROS_WORKON_COMMIT="d2d95e8af89939f893b1443135497c1f5572aebc"
CROS_WORKON_TREE="776139a53bc86333de8672a51ed7879e75909ac9"
CROS_WORKON_PROJECT="chromiumos/infra/build/empty-project"
CROS_WORKON_LOCALNAME="../platform/empty-project"

inherit cros-workon cros-fwupd

DESCRIPTION="Installs UEFI dbx update files used by fwupd."
HOMEPAGE="https://fwupd.org/lvfs/devices/"

FILENAMES=(
	# org.linuxfoundation.dbx.x64.firmware version 371
	"fc3feb015df2710fcfa07583d31b5975ee398357016699cfff067f422ab91e13-DBXUpdate-20230509-x64.cab"

	# org.linuxfoundation.dbx.ia32.firmware version 89
	"f2f984b66f262801f4b3d25d719b64c99c0869bc653c33c6691fb5c604b955c5-DBXUpdate-20230509-ia32.cab"
)
SRC_URI="${FILENAMES[*]/#/${CROS_FWUPD_URL}/}"
LICENSE="LVFS-Vendor-Agreement-v1"

KEYWORDS="*"

DEPEND=""
RDEPEND="sys-apps/fwupd"
