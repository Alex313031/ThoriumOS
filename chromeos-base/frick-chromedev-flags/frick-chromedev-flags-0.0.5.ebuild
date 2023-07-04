# Copyright (c) 2023 Alex313031. All rights reserved.
# Distributed under the terms of the GNU General Public License v3

EAPI="7"
inherit chrome-dev-flags 
DESCRIPTION="Appends Chromium commandline flags to /etc/chrome_dev.conf."
HOMEPAGE="https://github.com/Alex313031/ChromiumOS/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE="chrome-dev-flags kiosk_demo"
S=${WORKDIR}

RDEPEND="chromeos-base/chromeos-login"
DEPEND="${RDEPEND}"

CHROME_DEV_FLAGS="${CHROME_DEV_FLAGS}"

src_prepare() {
    eapply_user
    
    if use chrome-dev-flags; then
      CHROME_DEV_FLAGS="${CHROME_DEV_FLAGS} --shelf-hover-previews --show-component-extension-options --enable-ui-devtools --enable-features=EnableAppGridGhost --disable-features=CrostiniUseDlc"
    fi

    if use kiosk_demo; then
      CHROME_DEV_FLAGS="${CHROME_DEV_FLAGS} --force-kiosk-mode"
    fi
}
