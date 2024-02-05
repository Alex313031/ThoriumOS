# Copyright 2024 The Chromium OS Authors and Alex313031. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# https://www.chromium.org/chromium-os/external-bsp-hosting/

EAPI="7"

DESCRIPTION="Generic ebuild which satisifies virtual/chromeos-bsp.
This is a direct dependency of virtual/target-chromium-os, but is expected
to be overridden in an overlay for each specialized board.  A typical
non-generic implementation will install any board-specific configuration
files and drivers which are not suitable for inclusion in a generic board
overlay."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/"

LICENSE="BSD BSD-Google BZIP2 GPL-2 GPL-2+ GPL-3 LGPL-2.1 unRAR public-domain ThoriumOS-LICENSE"
SLOT="0"
KEYWORDS="*"
IUSE="chrome-dev-flags drivefs frick-wallpapers libassistant thoriumos widevine gflags"

#	dev-python/blinker
#	dev-python/flask
#	dev-python/itsdangerous
#	dev-python/werkzeug
#	media-libs/libjxl
#	net-misc/gsutil

RDEPEND="
	!chromeos-base/chromeos-bsp-null
	!media-libs/mesa-llvmpipe
	!sys-firmware/intel-microcode
	app-admin/pydf
	app-admin/sysstat
	app-arch/cabextract
	app-arch/cpio
	app-arch/gzip
	app-arch/p7zip
	app-arch/pbzip2
	app-arch/tar
	app-arch/unrar
	app-arch/unzip
	app-arch/xz-utils
	app-benchmarks/stress-ng
	app-editors/nano
	app-editors/qemacs
	app-editors/vim
	app-misc/beep
	app-misc/cmatrix
	app-misc/neofetch
	app-misc/screen
	app-misc/sl
	app-text/dos2unix
	chrome-dev-flags? ( chromeos-base/bash-skel )
	chromeos-base/assistant-dlc
	chromeos-base/chromeos-bsp-amd64-frick
	thoriumos? ( chromeos-base/chromeos-osrelease )
	chromeos-base/cros-trimly
	chromeos-base/oem-crx
	chromeos-base/vga-switcher
	libassistant? ( chromeos-base/libassistant )
	chrome-dev-flags? ( chromeos-base/frick-chromedev-flags )
	frick-wallpapers? ( chromeos-base/frick-oem-wallpapers )
	drivefs? ( chromeos-base/google-drive-fs )
	widevine? ( chromeos-base/libwidevine )
	gflags? ( dev-cpp/gflags )
	dev-python/cherrypy
	dev-python/dbus-python
	dev-python/virtualenv
	dev-util/mem
	dev-util/strace
	dev-vcs/git
	sci-libs/cln
	sys-firmware/b43-firmware
	sys-firmware/intel-ucode-firmware
	sys-firmware/sof-firmware
	sys-kernel/linux-firmware
	sys-firmware/mssl1680-firmware
	media-libs/cros-camera-hal-usb
	media-libs/display-link-bin
	media-libs/intel-lpe-audio-config
	media-libs/lpe-support-blacklist
	media-libs/lpe-support-topology
	media-libs/mesa-reven
	media-libs/x264
	media-libs/x265
	media-video/libva-utils
	net-analyzer/iftop
	net-analyzer/netperf
	net-analyzer/speedtest-cli
	net-analyzer/tcpdump
	net-fs/sshfs
	net-libs/http-parser
	net-libs/miniupnpc
	net-misc/bridge-utils
	net-misc/curl
	net-misc/iperf
	net-misc/iputils
	net-misc/libdiagcfg
	net-misc/rsync
	net-misc/telnet-bsd
	net-misc/tlsdate
	net-misc/wget
	net-wireless/rtw8852-firmware
	sys-apps/coreutils
	sys-apps/cpuid
	sys-apps/diffutils
	sys-apps/file
	sys-apps/findutils
	sys-apps/gptfdisk
	sys-apps/haveged
	sys-apps/i2c-tools
	sys-apps/iotools
	sys-apps/iucode_tool
	sys-apps/lm-sensors
	sys-apps/net-tools
	sys-apps/nvme-cli
	sys-apps/pciutils
	sys-apps/rng-tools
	sys-apps/smartmontools
	sys-apps/usbutils
	sys-fs/cryptsetup
	sys-fs/mtools
	sys-fs/ncdu
	sys-fs/ufiformat
	sys-libs/libcap
	sys-libs/zlib
	sys-process/htop
	sys-process/iotop
	sys-process/lsof
	sys-process/procps
	sys-process/psmisc
	sys-process/time
	virtual/chromeos-config-bsp
	virtual/cros-camera-hal
	virtual/cros-camera-hal-configs
	x11-apps/igt-gpu-tools
"

DEPEND="${RDEPEND}"

	# app-emulation/open-vm-tools
	# virtual/gentoo-extra-pkgs
	# !net-wireless/broadcom-sta
	# !net-wireless/rtl8188eu
	# !net-wireless/rtl8723au
	# !net-wireless/rtl8723bu
	# !net-wireless/rtl8812au
	# !net-wireless/rtl8821ce
