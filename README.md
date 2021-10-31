# ChromiumOS
<img src="https://github.com/Alex313031/ChromiumOS/blob/main/cros_bootsplash.png">

## ChromiumOS builds with x264, kernel 4.19, linux firmware/modules support, and extra packages.

- Extra packages include iotop, sysstat, htop, and sl.

&nbsp;&nbsp;&ndash; Inspired by and based off of ArnoldTheBat's builds which can be downloaded here > https://arnoldthebat.co.uk/wordpress/ \
&nbsp;&nbsp; - Also some code from FydeOS > https://github.com/FydeOS

Here is Arnold's source code which this project is based on > https://github.com/arnoldthebat/chromiumos - if you don't know how to work with these overlays, I invite you to learn, but one can just download the premade image in releases.

## Building
To start building > https://chromium.googlesource.com/chromiumos/docs/+/HEAD/developer_guide.md \
About overlays > https://www.chromium.org/chromium-os/how-tos-and-troubleshooting/working-with-your-overlay-faq

The files here can be copied in place on top of overlay-amd46-generic in *//chromiumos/src/overlays/overlay-amd64-generic*.

> To build with x264 and the extra packages, you must also
- Download chromium source code > https://chromium.googlesource.com/chromium/src/+/refs/heads/main/docs/linux/build_instructions.md
- Copy the *.gclient* file to the chromium source directory.
- Enter the CrOS SDK with `cros_sdk --chrome_root=/path/to/chromium`
- Run (inside cros_sdk) the export commands in the exports file.
- Run (inside cros_sdk) the emerge commands also in the exports file.
- When running './build_packages' append `--nowithdebug` \
&nbsp; - *This builds chromeos-base/chrome (Chromium) locally instead of downloading prebuilt binaries from google storage.*
- To build the disk image, use `./build_image --board=${BOARD} --noenable_rootfs_verification dev`
NOTE: To login, API Keys are needed. Follow > https://www.chromium.org/developers/how-tos/api-keys \
&nbsp;&nbsp; - Sample .googleapikeys and chrome_dev.conf files are provided.

The .zips in Releases contain **chromiumos_image.bin** which can be flashed to a USB Drive with https://www.balena.io/etcher/, *dd*, or *cros_flash* and booted on most processors supporting SSE3 or later. NOTE: NVidia is not supported. (yet)
