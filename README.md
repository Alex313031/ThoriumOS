# ChromiumOS
<img src="https://github.com/Alex313031/ChromiumOS/blob/main/cros_bootsplash.png">

## ChromiumOS builds with x264(H.264), kernel 4.19, linux firmware/modules support, and extra packages.

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
- To build the disk image, use `./build_image --board=${BOARD} --noenable_rootfs_verification dev` \
- NOTE: To log in, API Keys are needed. Follow > https://www.chromium.org/developers/how-tos/api-keys \
&nbsp;&nbsp; - Sample .googleapikeys and chrome_dev.conf files are provided. Putting your API Keys into the .googleapikeys file and putting the file in your home directory will bake them into the build, otherwise (and when using my releases), after login press `Ctrl+Alt+F2` to get to a shell, type *chronos* as the user name, then type `sudo mount -o rw,remount /` to mount the RootFS as read/write, then edit */etc/chrome_dev.conf* with `sudo nano /etc/chrome_dev.conf`, modeling it after the sample, but actually adding your API Key info into it. To get back to the GUI, press `Ctrl+Alt+F1`, and reboot to take effect. As per the API keys document above, you also have to add your Google Account to https://groups.google.com/u/1/a/chromium.org/g/google-browser-signin-testaccounts. It used to not be this way, until March 15, 2021 when Google vindictively restricted API Keys as per > https://blog.chromium.org/2021/01/limiting-private-api-availability-in.html, much to the displeasure of many developers and linux distributions. Unfortunately, to enable sync in Chromium on desktop and indeed to sign in at all on ChromiumOS, API Keys are needed. Public ones used to be available, but now private ones are needed, and I can't just share my own, because there is a quota on their usage to prevent wide distribution. If I were to do that, after just a couple of people installing and signing in on my builds, the servers would refuse any more requests. It is annoying and more work, I know, and might dissuade newbies from trying ChromiumOS, but there is no way around this.
- **To use Crostini**, disable the Crostini-Use-DLC flag in chrome://flags and reboot.

The .zips in Releases contain **chromiumos_image.bin** which can be flashed to a USB Drive with https://www.balena.io/etcher/, *dd*, or *cros_flash* and booted on most processors supporting SSE3 or later. NOTE: NVidia is not supported. (yet)
