# Copyright (c) 2022 Alex313031. All rights reserved.
# Distributed under the license specified in the root directory of this project.

EAPI="5"
inherit chrome-dev-flag 
DESCRIPTION="Append Chromium commandline flags"
HOMEPAGE="https://github.com/Alex313031/ChromiumOS/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE="frick-flags"

S=${WORKDIR}

CHROME_DEV_FLAGS="${CHROME_DEV_FLAGS}"

src_prepare() {
    if use frick-flags; then
      CHROME_DEV_FLAGS="${CHROME_DEV_FLAGS} --shelf-hover-previews --show-component-extension-options --enable-features=EnableAppGridGhost"
    fi
}
