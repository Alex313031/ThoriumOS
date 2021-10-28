# ChromiumOS
<img src="https://github.com/Alex313031/ChromiumOS/blob/main/cros_bootsplash.png">

## ChromiumOS builds with x264 and linux firmware/modules support.

&nbsp;&nbsp;&ndash; Inspired by and based off of ArnoldTheBat's builds which can be downloaded here > https://arnoldthebat.co.uk/wordpress/ \
&nbsp;&nbsp; - Also some code from FydeOS > https://github.com/FydeOS

Here is Arnold's source code which this project is based on > https://github.com/arnoldthebat/chromiumos - if you don't know how to work with these overlays, I invite you to learn, but one can just download the premade image in releases.

## Building
To start building > https://chromium.googlesource.com/chromiumos/docs/+/HEAD/developer_guide.md \
About overlays > https://www.chromium.org/chromium-os/how-tos-and-troubleshooting/working-with-your-overlay-faq

The files here can be copied in place on top of overlay-amd46-generic in *//chromiumos/src/overlays/overlay-amd64-generic*.

> To build with x264, you must also
- Download chromium source code > https://chromium.googlesource.com/chromium/src/+/refs/heads/main/docs/linux/build_instructions.md
- Copy the *.gclient* file to the chromium source directory.
- Enter the CrOS SDK with `cros_sdk --chrome_root=/path/to/chromium`
- Run `export CHROME_ORIGIN=LOCAL_SOURCE` from within the chroot.
- When running './build_packages' append `--nowithdebug` \
&nbsp; - *This builds chromeos-base/chrome (Chromium) locally instead of downloading prebuilt binaries from google storage.*

The .zips in Releases contain **chromiumos_image.bin** which can be flashed to a USB Drive with https://www.balena.io/etcher/, *dd*, or *cros_flash* and booted on most processors supporting SSE3 or later. NOTE: NVidia is not supported. (yet)
