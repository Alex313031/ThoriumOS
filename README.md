# ChromiumOS
<img src="https://github.com/Alex313031/ChromiumOS/blob/main/cros_bootsplash.png">

- ChromiumOS builds with x264 and linux firmware.

Inspired and based on ArnoldTheBats builds which can be downloaded here > https://arnoldthebat.co.uk/wordpress/

Here is Arnolds source code which this project is based on https://github.com/arnoldthebat/chromiumos - if you don't know how to work with these overlays I invite you to learn, but one can just download the premade image in releases.

To start building > https://chromium.googlesource.com/chromiumos/docs/+/HEAD/developer_guide.md \
Overlays - https://www.chromium.org/chromium-os/how-tos-and-troubleshooting/working-with-your-overlay-faq

The files here can be copied on top of overlay-amd46-generic in //chromiumos/src/overlays/overlay-amd64-generic.

 - The zips in releases contain chromiumos_image.bin which can be flashed to a USB Drive with https://www.balena.io/etcher/, dd, or cros_flash and booted on most processors supporting SSE3 or later.
