# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

# cros_workon applies only to ebuild and files directory. Use the
# canonical empty project.
CROS_WORKON_COMMIT="d2d95e8af89939f893b1443135497c1f5572aebc"
CROS_WORKON_TREE="776139a53bc86333de8672a51ed7879e75909ac9"
CROS_WORKON_PROJECT="chromiumos/infra/build/empty-project"
CROS_WORKON_LOCALNAME="platform/empty-project"

inherit cros-workon udev

DESCRIPTION="System configuration files containing quirks"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

src_install() {
	# Install udev files.
	udev_dorules "${FILESDIR}"/udev/*.rules

	# Install seccomp policy files.
	insinto /usr/share/policy
	doins "${FILESDIR}"/policy/*

	# Install helper script for alsa-init.
	exeinto /usr/share/cros/init
	doexe "${FILESDIR}"/scripts/alsactl-init.sh

	# Install extra alsactl-init configuration files.
	insinto /usr/share/alsa/init
	doins -r "${FILESDIR}"/alsa_init/preinit
}
