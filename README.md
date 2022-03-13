# ChromiumOS
<img src="https://github.com/Alex313031/ChromiumOS/blob/main/cros_bootsplash.png">

## ChromiumOS builds with x264(H.264) codecs, Kernel 5.10, Linux firmware/modules support, Intel microcode, and extra packages.

- Extra packages include iotop, iotools, sysstat, lm-sensors, pydf, cpuid, htop, sl, custom wallpapers, screenfetch-dev, pak, and TrImLy: a fstrim and e4defrag automator script I made for ChromiumOS. \
&nbsp; TrImLy > https://github.com/Alex313031/TrImLy/ \
&nbsp; ScreenFetch > https://github.com/KittyKatt/screenFetch \
&nbsp; Pak > https://github.com/myfreeer/chrome-pak-customizer
 - Sceenfetch is like neofetch for ChromiumOS
 - Pak can be used to unpack the .pak files used in any Chromium browser.

&nbsp;&nbsp;&ndash; Inspired by and based off of ArnoldTheBat's builds which can be downloaded here > https://arnoldthebat.co.uk/wordpress/ \
&nbsp;&nbsp;&ndash; Also some code from FydeOS > https://github.com/FydeOS

Here is Arnold's source code which this project is based on > https://github.com/arnoldthebat/chromiumos - if you don't know how to work with these overlays, I invite you to learn, but one can just download the premade image in releases.

## Installing
Follow https://chromium.googlesource.com/chromiumos/docs/+/HEAD/developer_guide.md#installing-your-chromium-os-image-to-your-hard-disk
However when running `/usr/sbin/chromeos-install` append `--dst /dev/sdxx`, where *sdx* is your hard drive i.e. *sda1*.
If you built your own image, API Keys will be needed to sign in. (See below.)

## Building
To start building > https://chromium.googlesource.com/chromiumos/docs/+/HEAD/developer_guide.md \
About overlays > https://www.chromium.org/chromium-os/how-tos-and-troubleshooting/working-with-your-overlay-faq \
Note that it is best if depot_tools, chromium, and chromiumos are all in $HOME. I don't know where you will put these dirs, so I just prefix things below with //.

The files here can be copied in place on top of overlay-amd46-generic in *//chromiumos/src/overlays/overlay-amd64-generic*.

> To build with x264 and the extra packages, you must also
- Download chromium source code > https://chromium.googlesource.com/chromium/src/+/refs/heads/main/docs/linux/build_instructions.md
- Copy the *.gclient* file to the chromium source directory (//chromium not //chromium/src/)
- Copy the *make.defaults* file to the location specified towards the top in the comments within the file.
- Go to //chromium/src/ and run `git checkout -f origin/main`, then `git rebase-update`, then `git fetch --tags`, then `gclient sync --with_branch_heads --with_tags -f -R -D` # This updates and syncs everything needed to build Chromium for CrOS.
- Next, go to //chromiumos/src/third_party/chromiumos-overlay/chromeos-base/chromeos-chrome/ and note the version in the .ebuild file (not the one with 9999 in its name) # This will be used in the next step to use the proper chromium version, which is usually slightly behind tip-o-tree for CrOS.
- Go back to //chromium/src and run `git checkout tags/98.0.4729.0` # Substituting for the actual version number you got before.
- Copy the *BUILD.gn* file to //chromium/src/build/config/compiler/ and overwrite the one in there.
- Enter the CrOS SDK with `cros_sdk --enter --chrome_root=/path/to/chromium` # Path should be absolute path, i.e. /home/alex/chromium/
- Run (inside cros_sdk) the export commands in the exports file.
- Run (inside cros_sdk) the emerge commands also in the exports file.
- Run `setup_board --board=${BOARD}`
- When running 'build_packages' use `build_packages --board=${BOARD} --nowithdebug --nowithautotest` \
&nbsp; - *This builds chromeos-base/chrome (Chromium) locally instead of downloading prebuilt binaries from google storage, and excludes debug stuff.*
- To build the disk image, use `build_image --board=${BOARD} --noenable_rootfs_verification dev`
- NEW NOTE - My releases now have API keys baked in, but follow below if you are building for yourself.
- NOTE: To log in, API Keys are needed. Follow > https://www.chromium.org/developers/how-tos/api-keys \
&nbsp;&nbsp; - Sample .googleapikeys and chrome_dev.conf files are provided. Putting your API Keys into the .googleapikeys file and putting the file in your home directory will bake them into the build, otherwise (and when using my releases), after login press `Ctrl+Alt+F2` to get to a shell, type *chronos* as the user name, then type `sudo mount -o rw,remount /` to mount the RootFS as read/write, then edit */etc/chrome_dev.conf* with `sudo nano /etc/chrome_dev.conf`, modeling it after the sample, but actually adding your API Key info into it. To get back to the GUI, press `Ctrl+Alt+F1`, and reboot to take effect. As per the API keys document above, you also have to add your Google Account to https://groups.google.com/u/1/a/chromium.org/g/google-browser-signin-testaccounts. It used to not be this way, until March 15, 2021 when Google vindictively restricted API Keys as per > https://blog.chromium.org/2021/01/limiting-private-api-availability-in.html, much to the displeasure of many developers and linux distributions. Unfortunately, to enable sync in Chromium on desktop and indeed to sign in at all on ChromiumOS, API Keys are needed. Public ones used to be available, but now private ones are needed, and I can't just share my own, because there is a quota on their usage to prevent wide distribution. If I were to do that, after just a couple of people installing and signing in on my builds, the servers would refuse any more requests. It is annoying and more work, I know, and might dissuade newbies from trying ChromiumOS, but there is no way around this.
- **To use Crostini**, disable the Crostini-Use-DLC flag in chrome://flags and reboot.
- If you modify any of the .ebuilds, DO NOT replace them with upstream Gentoo's, instead modify them in place. Some of the ebuilds have been modified to allow usage on CrOS, and some are slightly behind the latest version for compatability reasons.

The .7z files in Releases contain **chromiumos_image.bin** which can be flashed to a USB Drive with https://www.balena.io/etcher/, *dd*, or *cros_flash* and booted on most processors supporting SSE3 or later. NOTE: NVidia is not supported. (yet)

<img src="https://github.com/Alex313031/ChromiumOS/blob/main/ChromiumBook_black.png" width="256">
