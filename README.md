![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/alex313031/chromiumos?label=Latest Image%3A) &nbsp;![GitHub commit activity](https://img.shields.io/github/commit-activity/w/alex313031/chromiumos?color=blueviolet&label=Commit%20Activity%3A) &nbsp;![Subreddit subscribers](https://img.shields.io/reddit/subreddit-subscribers/ChromiumOS?style=social)
# ThoriumOS
<img src="https://github.com/Alex313031/ThoriumOS/blob/main/images/thoriumos_bootsplash.png">

## ChromiumOS fork with Thorium Browser, x264/x265 codecs, Widevine, Kernel 5.15, Linux Firmware/Modules support, Nouveau, Intel/AMD microcode, Google DriveFS, and extra packages.

> __SYNOPSIS: ThoriumOS aims to be the ChromiumOS counterpart to Thorium. It is based on tip-o-tree, and contains the compiler optimizations of Thorium applied to the whole OS. It contains a variety of extra developer friendly packages, and trys to support as much hardware as possible via kernel configuration, graphics stack configuration, and USE flags.__

> - ThoriumOS uses the Thorium Browser, which I also make for Linux, Windows, MacOS (x64 and M1), and other platforms like the Raspberry Pi > https://github.com/Alex313031/Thorium
> - Extra packages include iotop, iotools, sysstat, i2ctools, haveged, telnet, bridge-utils, lm-sensors, pydf, cpuid, htop, sl, custom wallpapers, screenfetch-dev, pak, and TrImLy: a fstrim and e4defrag automator script I made for ChromiumOS. \
> &ndash; _NOTE_: Please see PACKAGES.md for the full list of extra packages! \
> &nbsp; TrImLy > https://github.com/Alex313031/TrImLy/ \
> &nbsp; ScreenFetch > https://github.com/KittyKatt/screenFetch \
> &nbsp; Pak > https://github.com/myfreeer/chrome-pak-customizer \
> &nbsp;&nbsp;&ndash; Sceenfetch is like neofetch for ChromiumOS \
> &nbsp;&nbsp;&ndash; Pak can be used to unpack the .pak files used in any Chromium browser. \
> &nbsp;&nbsp;&ndash; Also added a script I made called memr to drop all caches, added handy aliases which can be found in the dot-bashrc file, and added good cmdline flags which can be found in the chrome_dev.conf file.

&nbsp;&nbsp;&ndash; Inspired by and based off of ArnoldTheBat's builds which can be downloaded here > https://arnoldthebat.co.uk/wordpress/ \
&nbsp;&nbsp;&ndash; Also some code from FydeOS > https://github.com/FydeOS \
&nbsp;&nbsp;&ndash; Also some code from NayuOS > https://nayuos.nexedi.com/

Here is Arnold's source code which this project is based on > https://github.com/arnoldthebat/chromiumos - if you don't know how to work with these overlays, I invite you to learn, but one can just download the premade image in releases.

## Installing <img src="https://github.com/Alex313031/Thorium/blob/main/logos/NEW/bulb_light.svg#gh-dark-mode-only"> <img src="https://github.com/Alex313031/Thorium/blob/main/logos/NEW/bulb_dark.svg#gh-light-mode-only">
The .7z files in Releases contain chromiumos_image.bin which can be flashed to a USB Drive with https://www.balena.io/etcher/, dd, or cros_flash and booted on most processors supporting AVX or later.
Follow https://chromium.googlesource.com/chromiumos/docs/+/HEAD/developer_guide.md#Installing-your-ChromiumOS-image-to-your-hard-disk
However when running `/usr/sbin/chromeos-install` append `--dst /dev/sdxx`, where *sdxx* is your hard drive i.e. *sda1*.
If you built your own image, API Keys will be needed to sign in. (See below.)

## Building <img src="https://github.com/Alex313031/Thorium/blob/main/logos/NEW/build_light.svg#gh-dark-mode-only"> <img src="https://github.com/Alex313031/Thorium/blob/main/logos/NEW/build_dark.svg#gh-light-mode-only">
To start building > https://chromium.googlesource.com/chromiumos/docs/+/HEAD/developer_guide.md \
About overlays > https://www.chromium.org/chromium-os/how-tos-and-troubleshooting/working-with-your-overlay-faq \
Note that it is best if depot_tools, chromium, and chromiumos are all in $HOME. I don't know where you will put these dirs, so I just prefix things below with //.

First, we assume the chromiumos source, chromium source, and this repo are all in $HOME. Then go into this repo and run `./setup.sh`, which will copy needed files over the chromiumos source tree and create a new overlay named overlay-amd64-frick. Run the `sed -i 's/ALL_BOARDS=(/ALL_BOARDS=(\n	amd64-frick\n/' ${HOME}/chromiumos/src/third_party/chromiumos-overlay/eclass/cros-board.eclass` command that ./setup.sh will tell you to do toward the end. This adds the overlay to this list of known board overlays.

> To build with x264 and the extra packages, you must also
- Download chromium source code > https://chromium.googlesource.com/chromium/src/+/refs/heads/main/docs/linux/build_instructions.md
- Copy the *.gclient* file to the chromium source directory (//chromium not //chromium/src/)
- Copy the *make.defaults* file to the location specified towards the top in the comments within the file.
- Go to //chromium/src/ and run `git checkout -f origin/main`, then `git rebase-update`, then `git fetch --tags`, then `gclient sync --with_branch_heads --with_tags -f -R -D` # This updates and syncs everything needed to build Chromium for CrOS.
- Next, go to //chromiumos/src/third_party/chromiumos-overlay/chromeos-base/chromeos-chrome/ and note the version in the .ebuild file (not the one with 9999 in its name) # This will be used in the next step to use the proper chromium version, which is usually slightly behind tip-o-tree for CrOS.
- Go back to //chromium/src and run `git checkout tags/98.0.4729.0`, and run `gclient sync --with_branch_heads --with_tags -f -R -D` again.  # Substituting for the actual version number you got before.
- To build Thorium for ThoriumOS, you should also follow instructions in that repo, including its setup.sh file.
- Enter the CrOS SDK with `cros_sdk --enter --chrome_root=/path/to/chromium` # Path should be absolute path, i.e. /home/alex/chromium/
- Run (inside cros_sdk) the export commands in the exports file.
- Run (inside cros_sdk) the build commands also in the exports file.
&nbsp; - *This builds chromeos-base/chrome (Chromium) locally instead of downloading prebuilt binaries from google storage, and excludes debug stuff.*
- To build the disk image, use `./build_image --board=${BOARD} --noenable_rootfs_verification dev`
- The exports file has other useful commands like updating the ChromiumOS checkout, flashing to usb, deleting the build output directory, and mounting the image locally.
- NEW NOTE - My releases now have API keys baked in, but follow below if you are building for yourself.
- NOTE: To log in, API Keys are needed. Follow > https://www.chromium.org/developers/how-tos/api-keys \
&nbsp;&nbsp; - Sample .googleapikeys and chrome_dev.conf files are provided. Putting your API Keys into the .googleapikeys file and putting the file in your home directory will bake them into the build (only if building Chromium locally), otherwise, after login press `Ctrl+Alt+F2` to get to a shell, type *chronos* as the user name, then type `sudo mount -o rw,remount /` to mount the RootFS as read/write, then edit */etc/chrome_dev.conf* with `sudo nano /etc/chrome_dev.conf`, modeling it after the sample, but actually adding your API Key info into it. To get back to the GUI, press `Ctrl+Alt+F1`, and reboot to take effect. As per the API keys document above, you also have to add your Google Account to https://groups.google.com/u/1/a/chromium.org/g/google-browser-signin-testaccounts. It used to not be this way, until March 15, 2021 when Google vindictively restricted API Keys as per > https://blog.chromium.org/2021/01/limiting-private-api-availability-in.html, much to the displeasure of many developers and linux distributions. Unfortunately, to enable sync in Chromium on desktop and indeed to sign in at all on ChromiumOS, API Keys are needed. Public ones used to be available, but now private ones are needed, and I can't just share my own, because there is a quota on their usage to prevent wide distribution. If I were to do that, after just a couple of people installing and signing in on my builds, the servers would refuse any more requests. It is annoying and more work, I know, and might dissuade newbies from trying ChromiumOS, but there is no way around this.
- If you modify any of the .ebuilds, DO NOT replace them with upstream Gentoo's, instead modify them in place. Some of the ebuilds have been modified to allow usage on CrOS, and some are slightly behind the latest version for compatability reasons.

The .7z files in Releases contain **chromiumos_image.bin** which can be flashed to a USB Drive with https://www.balena.io/etcher/, *dd*, or *cros_flash* and booted on most processors supporting AVX or later.

<img src="https://github.com/Alex313031/ThoriumOS/blob/main/images/ChromiumBook_Black.png" width="256">
