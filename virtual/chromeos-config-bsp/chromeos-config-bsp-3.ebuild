# Copyright 2022 The Chromium OS Authors and Alex313031. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

DESCRIPTION="ChromeOS Unibuild Config virtual package"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/chromeos-config/README.md"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

DEPEND="chromeos-base/chromeos-config-bsp"
RDEPEND="${DEPEND}"
