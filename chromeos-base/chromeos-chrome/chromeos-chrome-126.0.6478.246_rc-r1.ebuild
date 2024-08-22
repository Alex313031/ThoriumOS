# Copyright 2024 The ChromiumOS Authors and Alex313031
# Distributed under the terms of the GNU General Public License v2

# Usage: by default, downloads chromium browser from the build server.
# If CHROME_ORIGIN is set to one of {SERVER_SOURCE, LOCAL_SOURCE, LOCAL_BINARY},
# the build comes from the chromimum source repository (gclient sync),
# build server, locally provided source, or locally provided binary.
# If you are using SERVER_SOURCE, a gclient template file that is in the files
# directory which will be copied automatically during the build and used as
# the .gclient for 'gclient sync'.
# If building from LOCAL_SOURCE or LOCAL_BINARY specifying BUILDTYPE
# will allow you to specify "Debug" or another build type; "Release" is
# the default.

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )
inherit autotest-deponly binutils-funcs chromium-source cros-credentials cros-constants cros-remoteexec cros-sanitizers eutils flag-o-matic multilib toolchain-funcs user python-any-r1 multiprocessing

DESCRIPTION="Open-source version of Google Chrome web browser"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD-Google chrome_internal? ( Google-TOS )"
SLOT="0/${PVR}"
KEYWORDS="*"
IUSE="
	afdo_generate
	+afdo_use
	afdo_verify
	+accessibility
	app_shell
	arc_hw_oemcrypto
	asan
	bluetooth
	+build_tests
	camera_angle_backend
	cdm_factory_daemon
	chrome_debug
	cfm
	+chrome_cfi_thinlto
	chrome_debug_tests
	chrome_dcheck
	chrome_internal
	+chrome_media
	+chrome_remoting
	clang_tidy
	component_build
	compressed_ash
	cros-debug
	crosier_binary
	debug_fission
	+dwarf5
	+fonts
	hw_details
	+feature_management
	+hevc_codec
	+highdpi
	intel_oemcrypto
	internal_gles_conform
	+libcxx
	+libinput
	merge_request
	mojo
	msan
	+nacl
	neon
	+oobe_config
	opengl
	opengles
	optee_oemcrypto
	protected_av1
	strict_toolchain_checks
	subpixel_rendering
	touchview
	tpm_dynamic
	ubsan
	v4l2_codec
	v4lplugin
	+vaapi
	+verbose
	vtable_verify
	xkbcommon
	+widevine
	"
# AFDO generate does not support debug_fission.
# AFDO verify does not use production AFDO.
REQUIRED_USE="
	afdo_generate? ( !debug_fission )
	afdo_verify? ( !afdo_use )
	"

# The gclient hooks that run in src_prepare hit the network.
# https://crbug.com/731905
RESTRICT="network-sandbox mirror"

# Do not strip the nacl_helper_bootstrap binary because the binutils
# objcopy/strip mangles the ELF program headers.
# TODO(mcgrathr,vapier): This should be removed after portage's prepstrip
# script is changed to use eu-strip instead of objcopy and strip.
STRIP_MASK+=" */nacl_helper_bootstrap"

# Portage version without optional portage suffix.
CHROME_VERSION="${PV/_*/}"

# chrome destination directory
CHROME_DIR=/opt/google/chrome
D_CHROME_DIR="${D}/${CHROME_DIR}"

# For compilation/local chrome
BUILDTYPE="${BUILDTYPE:-Release}"
BOARD="${BOARD:-${SYSROOT##/build/}}"
BUILD_OUT="${BUILD_OUT:-out_${BOARD}}"
ANGLE_BUILD_OUT="${BUILD_OUT}_angle"
# WARNING: We are using a symlink now for the build directory to work around
# command line length limits. This will cause problems if you are doing
# parallel builds of different boards/variants.
# Unsetting BUILD_OUT_SYM will revert this behavior
BUILD_OUT_SYM="c"
ANGLE_BUILD_OUT_SYM="${BUILD_OUT_SYM}_angle"

# The following entry will be modified automatically for verifying AFDO profile.
UNVETTED_AFDO_FILE=""

COMMON_DEPEND="
	app-crypt/mit-krb5
	bluetooth? ( net-wireless/bluez )
	chromeos-base/gestures
	chromeos-base/libevdev:=
	chrome_internal? ( chromeos-base/quickoffice )
	dev-libs/expat
	dev-libs/libffi
	dev-libs/nspr
	>=dev-libs/nss-3.12.2
	libinput? ( dev-libs/libinput:= )
	>=media-libs/alsa-lib-1.0.19
	media-libs/fontconfig
	media-libs/libsync
	x11-libs/libdrm
	media-libs/minigbm
	v4lplugin? ( media-libs/libv4lplugins )
	media-libs/libcras
	net-print/cups
	opengl? ( virtual/opengl )
	opengles? ( virtual/opengles )
	sys-apps/dbus
	sys-apps/pciutils
	virtual/udev
	sys-libs/libcap
	chrome_remoting? ( sys-libs/pam )
	vaapi? ( x11-libs/libva:= )
	xkbcommon? (
		x11-libs/libxkbcommon
		x11-misc/xkeyboard-config
	)
	libcxx? (
		sys-libs/libcxx
	)
"

RDEPEND="
	${COMMON_DEPEND}
	accessibility? (
		app-accessibility/brltty
		app-accessibility/espeak-ng
		app-accessibility/googletts
	)
	app-arch/bzip2
	app-arch/sharutils
	app-misc/edid-decode
	~chromeos-base/chrome-icu-${PV}
	fonts? ( chromeos-base/chromeos-fonts )
	chromeos-base/iioservice
	chromeos-base/mojo_service_manager
	oobe_config? ( chromeos-base/oobe_config )
"

DEPEND="
	${COMMON_DEPEND}
	opengles? ( x11-drivers/opengles-headers:= )
"

# shellcheck disable=SC2016
BDEPEND="
	app-crypt/mit-krb5
	app-misc/ca-certificates
	dev-libs/glib
	dev-util/gperf
	$(python_gen_any_dep '
		dev-python/chardet[${PYTHON_USEDEP}]
	')
	dev-vcs/git
	media-libs/fontconfig
	net-misc/rsync
	arm64? (
		cross-armv7a-cros-linux-gnueabihf/binutils
		cross-armv7a-cros-linux-gnueabihf/compiler-rt
		cross-armv7a-cros-linux-gnueabihf/glibc
		cross-armv7a-cros-linux-gnueabihf/linux-headers
		cross-armv7a-cros-linux-gnueabihf/llvm-libunwind
	)
"

python_check_deps() {
	python_has_version -b "dev-python/chardet[${PYTHON_USEDEP}]"
}

PATCHES=()

AUTOTEST_COMMON="src/chrome/test/chromeos/autotest/files"
AUTOTEST_DEPS="${AUTOTEST_COMMON}/client/deps"
AUTOTEST_DEPS_LIST="chrome_test telemetry_dep"

IUSE="${IUSE} +autotest"


QA_TEXTRELS="*"
QA_EXECSTACK="*"
QA_PRESTRIPPED="*"

use_nacl() {
	# 32bit asan conflicts with nacl: crosbug.com/38980
	! (use asan && [[ ${ARCH} == "x86" ]]) && \
	! use component_build && use nacl
}

# Like the `usex` helper:
# Usage: echox [int] [echo-if-true] [echo-if-false]
# If [int] is 0, then echo the 2nd arg (default of yes), else
# echo the 3rd arg (default of no).
echox() {
	# Like the `usex` helper.
	[[ ${1:-$?} -eq 0 ]] && echo "${2:-yes}" || echo "${3:-no}"
}
# shellcheck disable=SC2120 # for suppressing a warning of never passed argument.
echotf() { echox "${1:-$?}" true false ; }
usetf()  { usex "$1" true false ; }

set_build_args() {
	# shellcheck disable=SC2119
	# suppressing the false warning not to specify the optional argument of 'echotf".
	use_protected_av1=$(use intel_oemcrypto || use optee_oemcrypto || use protected_av1; echotf)
	# shellcheck disable=SC2119
	# suppressing the false warning not to specify the optional argument of 'echotf".
	use_hevc_codec=$(use hevc_codec && (use chrome_internal || use chrome_media); echotf)

	BUILD_ARGS=(
		"is_chromeos_device=true"
		# is_official_build sometimes implies extra optimizations (e.g. it will allow
		# ThinLTO to optimize more aggressively, if ThinLTO is enabled). Please note
		# that, despite the name, it should be usable by external users.
		#
		# Sanitizers don't like official builds.
		"is_official_build=true"
		"thin_lto_enable_cache=true"
		"enable_stripping=true"
		"dcheck_always_on=false"
		"exclude_unwind_tables=true"
		"enable_iterator_debugging=false"
		"disable_fieldtrial_testing_config=true"
		"enable_resource_allowlist_generation=false"
		"enable_profiling=false"
		"is_component_build=false"
		"symbol_level=0"
		"enable_nacl=true"
		"optimize_webui=true"
		"enable_webui_tab_strip=true"
		"treat_warnings_as_errors=false"
		"use_lld=true"
		"v8_symbol_level=0"
		"v8_enable_fast_torque=true"
		"blink_symbol_level=0"
		"enable_precompiled_headers=false"
		"media_use_ffmpeg=true"
		"media_use_libvpx=true"
		"enable_hls_demuxer=true"
		"enable_ink=false"
		"enable_discovery=true"
		"enable_cros_media_app=false"
		"enable_ffmpeg_video_decoders=true"
		"is_component_ffmpeg=false"
		"use_webaudio_ffmpeg=false"
		"use_webaudio_pffft=true"
		"use_vaapi=true"
		"enable_widevine=$(usetf widevine)"
		"bundle_widevine_cdm=true"
		"ignore_missing_widevine_signing_cert=true"
		"enable_media_drm_storage=true"
		"enable_hangout_services_extension=true"
		"rtc_use_h264=true"
		"rtc_include_ilbc=true"
		"rtc_build_examples=false"
		"rtc_use_pipewire=false"
		"enable_vr=true"
		"enable_platform_hevc=true"
		"enable_hevc_parser_and_hw_decoder=true"
		"platform_has_optional_hevc_support=true"
		"enable_platform_ac3_eac3_audio=true"
		"enable_platform_ac4_audio=false"
		"enable_platform_dolby_vision=true"
		"enable_platform_encrypted_dolby_vision=true"
		"enable_platform_mpeg_h_audio=true"
		"enable_platform_dts_audio=true"
		"enable_mse_mpeg2ts_stream_parser=true"
		"use_text_section_splitting=true"
		"use_thin_lto=true"
		"thin_lto_enable_optimizations=true"
		"init_stack_vars_zero=true"

		"is_debug=false"
		"${EXTRA_GN_ARGS}"
		"enable_pseudolocales=$(usetf cros-debug)"
		"use_arc_protected_media=$(usetf arc_hw_oemcrypto)"
		"use_chromeos_protected_av1=${use_protected_av1}"
		"use_chromeos_protected_media=$(usetf cdm_factory_daemon)"
		"enable_hevc_parser_and_hw_decoder=${use_hevc_codec}"
		"use_v4l2_codec=$(usetf v4l2_codec)"
		"use_v4lplugin=$(usetf v4lplugin)"
		"use_vaapi=$(usetf vaapi)"
		"use_xkbcommon=$(usetf xkbcommon)"
		"enable_remoting=$(usetf chrome_remoting)"
		# shellcheck disable=SC2119
		# suppressing the false warning not to specify the optional argument of 'echotf".
		"enable_nacl=$(use_nacl; echotf)"
		# use_system_minigbm is set below.

		"is_cfm=$(usetf cfm)"

		# Clang features.
		"is_asan=$(usetf asan)"
		"is_msan=$(usetf msan)"
		"is_ubsan=$(usetf ubsan)"
		"is_clang=true"
		"use_thin_lto=$(usetf chrome_cfi_thinlto)"
		"is_cfi=$(usetf chrome_cfi_thinlto)"
		"use_dwarf5=$(usetf dwarf5)"
		# Disable use of debian sysroot for host builds.
		"use_sysroot=false"

		# Assistant integration tests are only run on the Chromium bots,
		# but they increase the size of libassistant.so by 1.3MB so we
		# disable them here.
		"enable_assistant_integration_tests=false"

		# Add libinput to handle touchpad.
		"use_libinput=$(usetf libinput)"

		# Enable NSS slots software fallback when we are using runtime TPM selection.
		"nss_slots_software_fallback=$(usetf tpm_dynamic)"

		# Add hardware information to feedback logs and chrome://system.
		"is_chromeos_with_hw_details=$(usetf hw_details)"

		# Whether the target board has any device models supporting the
		# "time of day" wallpaper and screensaver collections.
		"is_time_of_day_supported=$(usetf feature_management)"

		# Merge advanced features.
		"enable_merge_request=$(usetf merge_request)"
	)

	ANGLE_BUILD_ARGS=(
		"use_ozone=false"
		"ozone_platform_cast=false"
		"ozone_platform_drm=false"
		"ozone_platform_flatland=false"
		"ozone_platform_gbm=false"
		"ozone_platform_headless=false"
		"ozone_platform_x11=false"
		"ozone_platform_wayland=false"
		"angle_build_all=true"
		"angle_build_mesa=false"
		"angle_enable_cl=false"
		"angle_enable_vulkan=true"
		"angle_enable_vulkan_validation_layers=false"
		"angle_use_custom_libvulkan=false"
		"angle_enable_gl=false"
		"angle_enable_gl_desktop_backend=false"
		"angle_enable_null=false"
		"angle_use_vulkan_null_display=false"
		"angle_use_vulkan_display=true"
		"angle_vulkan_display_mode=\"offscreen\""
		"angle_use_wayland=false"
		"angle_use_x11=false"
		"angle_enable_context_mutex=true"
		"angle_enable_share_context_lock=true"
	)

	# BUILD_STRING_ARGS needs appropriate quoting. So, we keep them separate and
	# add them to BUILD_ARGS at the end.
	BUILD_STRING_ARGS=(
		"target_sysroot=${SYSROOT}"
		"system_libdir=$(get_libdir)"
		"pkg_config=$(tc-getPKG_CONFIG)"
		"target_os=chromeos"
		"host_pkg_config=$(tc-getBUILD_PKG_CONFIG)"
		"clang_diagnostic_dir=/tmp/clang_crash_diagnostics"
	)
	use internal_gles_conform && BUILD_ARGS+=( "internal_gles2_conform_tests=true" )

	# Ozone platforms.
	# TODO: Move this to browser side and delete these overrides.
	BUILD_STRING_ARGS+=( "ozone_platform=gbm" )
	BUILD_ARGS+=(
		"ozone_auto_platforms=false"
		"ozone_platform_gbm=true"
		"ozone_platform_headless=true"
		"use_system_minigbm=true"
		"use_system_libdrm=true"
	)
	if ! use "subpixel_rendering" || use "touchview"; then
		BUILD_ARGS+=( "subpixel_font_rendering_disabled=true" )
	fi

	# Set proper build args for the arch
	case "${ARCH}" in
	x86)
		BUILD_STRING_ARGS+=( "target_cpu=x86" )
		;;
	arm)
		BUILD_ARGS+=(
			"arm_use_neon=$(usetf neon)"
			# To workaround the 4GB debug limit. crbug.com/792999.
			"blink_symbol_level=1"
		)
		BUILD_STRING_ARGS+=(
			"target_cpu=arm"
			"arm_float_abi=hard"
		)
		local arm_arch=$(get-flag march)
		if [[ -n "${arm_arch}" ]]; then
			BUILD_STRING_ARGS+=( "arm_arch=${arm_arch}" )
			# Remove -march flag from {CC,CPP,CXX}FLAGS etc.
			# Chromium will append -march=${arm_arch}.
			filter-flags "-march=*"
		fi
		;;
	arm64)
		BUILD_STRING_ARGS+=(
			"target_cpu=arm64"
		)
		local arm_arch=$(get-flag march)
		if [[ -n "${arm_arch}" ]]; then
			BUILD_STRING_ARGS+=( "arm_arch=${arm_arch}" )
			# Remove -march flag from {CC,CPP,CXX}FLAGS etc.
			# Chromium will append -march=${arm_arch}.
			filter-flags "-march=*"
		fi
		;;
	amd64)
		BUILD_STRING_ARGS+=( "target_cpu=x64" )
		;;
	*)
		die "Unsupported architecture: ${ARCH}"
		;;
	esac

	if use chrome_internal; then
		# Adding chrome branding specific variables.
		BUILD_ARGS+=( "is_chrome_branded=true" )
		# This test can only be build from internal sources.
		BUILD_ARGS+=( "internal_gles2_conform_tests=true" )
		export CHROMIUM_BUILD='_google_Chrome'
		export OFFICIAL_BUILD='1'
		export CHROME_BUILD_TYPE='_official'
	elif use chrome_media; then
		echo "Building Chromium with additional media codecs and containers."
		BUILD_ARGS+=( "proprietary_codecs=true" )
		BUILD_STRING_ARGS+=( "ffmpeg_branding=ChromeOS" )
	fi

	if use component_build; then
		BUILD_ARGS+=( "is_component_build=true" )
	fi

	if cros-remoteexec_use_remoteexec; then
		BUILD_ARGS+=(
			"use_remoteexec=true"
		)
		BUILD_STRING_ARGS+=(
			# reclient configs in CHROME_ROOT are for simplechrome only. So for
			# ebuilds, instead we override GN args here to specify the correct
			# rewrapper config to use.
			"rbe_cfg_dir=${CHROME_ROOT}/src/buildtools/reclient_cfgs/linux_chroot"

			# For chroot based builds, this is overridden to be  '/'
			# (where we run our build actions).
			"rbe_exec_root=/"
		)

		cros-remoteexec_initialize
	fi

	if use chrome_debug; then
		# Use debug fission to avoid 4GB limit of ELF32 (see crbug.com/595763).
		# Using -g1 causes problems with crash server (see crbug.com/601854).
		# Disable debug_fission for bots which generate AFDO profile. (see crbug.com/704602).
		local debug_level=2
		if use afdo_generate; then
			# Limit debug info to -g1 to keep the binary size within 4GB.
			# Production builds do not use "-debug_fission". But it is used
			# by the AFDO builders and AFDO tools are fine with debug_level=1.
			# Excessive debug info size is also becoming a problem on amd64,
			# so it's applicable now to all archs.
			debug_level=1
		fi
		BUILD_ARGS+=(
			"use_debug_fission=$(usetf debug_fission)"
			"symbol_level=${debug_level}"
		)
		if use debug_fission; then
			# The breakpad cannot handle the debug files generated by
			# llvm and debug fission properly. crosbug.com/710605
			append-flags -fno-split-dwarf-inlining
		fi
	fi

	# dcheck_always_on may default to true depending on the value of args
	# above, which we might not want. So let the chrome_dcheck USE flag
	# determine its value.
	BUILD_ARGS+=("dcheck_always_on=$(usetf chrome_dcheck)")
}

unpack_chrome() {
	# Lock the destination directory to avoid having multiple ebuilds writing
	# to the same directory concurrently.
	local cmd=(
		flock
		"${CHROME_DISTDIR}"
		"${CHROMITE_BIN_DIR}"/sync_chrome
	)
	use chrome_internal && cmd+=( --internal )
	if [[ "${CHROME_VERSION}" != "9999" ]]; then
		cmd+=( "--tag=${CHROME_VERSION}" )
	fi
	# --reset tells sync_chrome to blow away local changes and to feel
	# free to delete any directories that get in the way of syncing. This
	# is needed for unattended operation.
	cmd+=( --reset "--gclient=${EGCLIENT}" "${CHROME_DISTDIR}" )
	elog "${cmd[*]}"
	# TODO(crbug.com/1103048): Disable the sandbox when syncing the code.
	# It seems to break gclient execution at random for unknown reasons.
	# Children stop being tracked, or no git repos actually get cloned.
	SANDBOX_ON=0 "${cmd[@]}" || die
}

decide_chrome_origin() {
	if [[ "${PV}" == "9999" ]]; then
		# LOCAL_SOURCE is the default for cros_workon.
		# Warn the user if CHROME_ORIGIN is already set.
		if [[ -n "${CHROME_ORIGIN}" && "${CHROME_ORIGIN}" != LOCAL_SOURCE ]]; then
			ewarn "CHROME_ORIGIN is already set to ${CHROME_ORIGIN}."
			ewarn "This will prevent you from building from your local checkout."
			ewarn "Please run 'unset CHROME_ORIGIN' to reset Chrome"
			ewarn "to the default source location."
		fi
		: "${CHROME_ORIGIN:=LOCAL_SOURCE}"
	else
		# By default, pull from server.
		: "${CHROME_ORIGIN:=SERVER_SOURCE}"
	fi
}

sandboxless_ensure_directory() {
	local dir
	for dir in "$@"; do
		if [[ ! -d "${dir}" ]] ; then
			# We need root access to create these directories, so we need to
			# use sudo. This implicitly disables the sandbox.
			sudo mkdir -p "${dir}" || die
			sudo chown "${PORTAGE_USERNAME}:${PORTAGE_GRPNAME}" "${dir}" || die
			sudo chmod 0755 "${dir}" || die
		fi
	done
}

src_unpack() {
	echo
	ewarn "If you want to develop or hack on the browser itself, you should follow the"
	ewarn "simple chrome workflow instead of using emerge:"
	ewarn "https://chromium.googlesource.com/chromiumos/docs/+/HEAD/simple_chrome_workflow.md"
	ewarn ""
	ewarn "Otherwise, if you have a Chrome checkout already present on your machine, you can"
	ewarn "re-enter the cros_sdk with the --chrome-root arg and set CHROME_ORIGIN to"
	ewarn "LOCAL_SOURCE. This will bypass the lengthy sync_chrome phase here."
	ewarn "Note: when using --chrome-root, the ebuild won't update or modify the Chrome checkout."
	ewarn "So make sure it's at a compatible Chrome version before proceeding."
	echo

	tc-export CC CXX
	local WHOAMI=$(whoami)

	local chrome_src="chrome-src"
	if use chrome_internal; then
		chrome_src+="-internal"
	fi

	# Add depot_tools to PATH, local chroot builds fail otherwise. Also used
	# for cipd, which is used to fetch reclient build cfg files.
	export PATH=${PATH}:${DEPOT_TOOLS}

	# CHROME_CACHE_DIR is used for storing output artifacts.
	: "${CHROME_CACHE_DIR:="/var/cache/chromeos-chrome/${chrome_src}"}"
	addwrite "${CHROME_CACHE_DIR}"

	# CHROME_DISTDIR is used for storing the source code, if any source code
	# needs to be unpacked at build time (e.g. in the SERVER_SOURCE scenario).
	: "${CHROME_DISTDIR:="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/${chrome_src}"}"
	addwrite "${CHROME_DISTDIR}"

	# Create storage directories.
	sandboxless_ensure_directory "${CHROME_DISTDIR}" "${CHROME_CACHE_DIR}"

	cros-credentials_setup

	decide_chrome_origin

	case "${CHROME_ORIGIN}" in
	LOCAL_SOURCE|SERVER_SOURCE|LOCAL_BINARY)
		einfo "CHROME_ORIGIN VALUE is ${CHROME_ORIGIN}"
		;;
	*)
		die "CHROME_ORIGIN not one of LOCAL_SOURCE, SERVER_SOURCE, LOCAL_BINARY"
		;;
	esac

	# Prepare and set CHROME_ROOT based on CHROME_ORIGIN.
	# CHROME_ROOT is the location where the source code is used for compilation.
	# If we're in SERVER_SOURCE mode, CHROME_ROOT is CHROME_DISTDIR. In LOCAL_SOURCE
	# mode, this directory may be set manually to any directory.
	# These are set here because $(whoami) returns the proper user here,
	# but 'root' at the root level of the file
	case "${CHROME_ORIGIN}" in
	(SERVER_SOURCE)
		elog "Using CHROME_VERSION = ${CHROME_VERSION}"
		if [[ ${WHOAMI} == "chrome-bot" ]]; then
			if [[ -d "${CHROME_DISTDIR}/src" ]]; then
				# TODO: Should add a sanity check that the version checked out is
				# what we actually want.  Not sure how to do that though.
				elog "Skipping syncing as chromite.api.PackageService/NeedsChromeSource and subsequent steps correctly synced source."
			else
				ewarn "Chrome has not been checked out to ${CHROME_DISTDIR} as expected via chromite."
				ewarn "This is not good."
				ewarn "Please compare the following against the output from chromite.api.PackageService/NeedsChromeSource:"
				ewarn "USE flags: ${USE:-}"
				ewarn "IUSE flags: ${IUSE}"
				ewarn "FEATURES flags: ${FEATURES}"
				ewarn "Proceeding to manually sync source via the ebuild."
				unpack_chrome
			fi
		else
			unpack_chrome
		fi

		elog "set the chrome source root to ${CHROME_DISTDIR}"
		elog "From this point onwards there is no difference between \
			SERVER_SOURCE and LOCAL_SOURCE, since the fetch is done"
		CHROME_ROOT=${CHROME_DISTDIR}
		;;
	(LOCAL_SOURCE)
		: "${CHROME_ROOT:=/home/${WHOAMI}/chrome_root}"
		if [[ ! -d "${CHROME_ROOT}/src" ]]; then
			die "${CHROME_ROOT} does not contain a valid chromium checkout!"
		fi
		addwrite "${CHROME_ROOT}"
		;;
	esac

	case "${CHROME_ORIGIN}" in
	LOCAL_SOURCE|SERVER_SOURCE)
		set_build_args
		;;
	esac

	# FIXME: This is the normal path where ebuild stores its working data.
	# Chrome builds inside distfiles because of speed, so we at least make
	# a symlink here to add compatibility with autotest eclass which uses this.
	ln -sf "${CHROME_ROOT}" "${WORKDIR}/${P}" || die

	if use internal_gles_conform; then
		local CHROME_GLES2_CONFORM=${CHROME_ROOT}/src/third_party/gles2_conform
		local CROS_GLES2_CONFORM=/home/${WHOAMI}/trunk/src/third_party/gles2_conform
		if [[ ! -d "${CHROME_GLES2_CONFORM}" ]]; then
			if [[ -d "${CROS_GLES2_CONFORM}" ]]; then
				ln -s "${CROS_GLES2_CONFORM}" "${CHROME_GLES2_CONFORM}" || die
				einfo "Using GLES2 conformance test suite from ${CROS_GLES2_CONFORM}"
			else
				die "Trying to build GLES2 conformance test suite without ${CHROME_GLES2_CONFORM} or ${CROS_GLES2_CONFORM}"
			fi
		fi
	fi

	if use afdo_use; then
		# Use AFDO profile downloaded in Chromium source code
		# If needed profiles other than "silvermont", please set the variable
		# ${AFDO_PROFILE_SOURCE} accordingly.
		local afdo_src="${AFDO_PROFILE_SOURCE:-atom}"
		BUILD_ARGS+=( "clang_use_default_sample_profile=true" )
		BUILD_STRING_ARGS+=( "chromeos_afdo_platform=${afdo_src}" )
	fi

	# Use to verify a local unvetted AFDO file.
	if use afdo_verify; then
		if [[ ! -e "${UNVETTED_AFDO_FILE}" ]]; then
			die "Cannot find ${UNVETTED_AFDO_FILE} to build Chrome."
		fi
		BUILD_STRING_ARGS+=( "clang_sample_profile_path=${UNVETTED_AFDO_FILE}" )
	fi
}

add_api_keys() {
	# awk script to extract the values out of the file.
	local EXTRACT="{ gsub(/[',]/, \"\", \$2); print \$2 }"
	local api_key=$(awk "/google_api_key/ ${EXTRACT}" "$1")
	local client_id=$(awk "/google_default_client_id/ ${EXTRACT}" "$1")
	local client_secret=$(awk "/google_default_client_secret/ ${EXTRACT}" "$1")

	BUILD_STRING_ARGS+=(
		"google_api_key=${api_key}"
		"google_default_client_id=${client_id}"
		"google_default_client_secret=${client_secret}"
	)
}

src_prepare() {
	# Must call eapply_user in EAPI 7, but this function is a no-op here.
	eapply_user

	if [[ "${CHROME_ORIGIN}" != "LOCAL_SOURCE" &&
			"${CHROME_ORIGIN}" != "SERVER_SOURCE" ]]; then
		return
	fi

	elog "${CHROME_ROOT} should be set here properly"
	cd "${CHROME_ROOT}/src" || die "Cannot chdir to ${CHROME_ROOT}"

	# We do symlink creation here if appropriate.
	mkdir -p "${CHROME_CACHE_DIR}/src/${BUILD_OUT}" || die
	if [[ -n "${BUILD_OUT_SYM}" ]]; then
		rm -rf "${BUILD_OUT_SYM}" || die "Could not remove symlink"
		ln -sfT "${CHROME_CACHE_DIR}/src/${BUILD_OUT}" "${BUILD_OUT_SYM}" ||
			die "Could not create symlink for output directory"
	fi

	if use camera_angle_backend; then
		mkdir -p "${CHROME_CACHE_DIR}/src/${ANGLE_BUILD_OUT}" || die
		if [[ -n "${ANGLE_BUILD_OUT_SYM}" ]]; then
			rm -rf "${ANGLE_BUILD_OUT_SYM}" || die "Could not remove symlink"
			ln -sfT "${CHROME_CACHE_DIR}/src/${ANGLE_BUILD_OUT}" "${ANGLE_BUILD_OUT_SYM}" ||
				die "Could not create symlink for output directory"
		fi
	fi

	# Apply patches for non-localsource builds.
	if [[ "${CHROME_ORIGIN}" == "SERVER_SOURCE" && ${#PATCHES[@]} -gt 0 ]]; then
		eapply "${PATCHES[@]}"
	fi

	local WHOAMI=$(whoami)
	# Get the credentials to fake home directory so that the version of chromium
	# we build can access Google services. First, check for Chrome credentials.
	if [[ ! -d google_apis/internal ]]; then
		# Then look for Chrome OS supplied credentials.
		local PRIVATE_OVERLAYS_DIR=/home/${WHOAMI}/trunk/src/private-overlays
		local GAPI_CONFIG_FILE=${PRIVATE_OVERLAYS_DIR}/chromeos-overlay/googleapikeys
		if [[ ! -f "${GAPI_CONFIG_FILE}" ]]; then
			# Then developer credentials.
			GAPI_CONFIG_FILE=/home/${WHOAMI}/.googleapikeys
		fi
		if [[ -f "${GAPI_CONFIG_FILE}" ]]; then
			add_api_keys "${GAPI_CONFIG_FILE}"
		fi
	fi
}

setup_test_lists() {
	# These tests are not executed directly as unit-tests on CQ, but rather they
	# are wrapped and executed as tast tests, or they are executed as part of
	# chrome-binary-tests ebuild.

	TEST_FILES=(
		capture_unittests
		dawn_end2end_tests
		dawn_unittests
		fake_dmserver
		libtest_trace_processor.so
		libvk_swiftshader.so
		jpeg_decode_accelerator_unittest
		ozone_gl_unittests
		ozone_integration_tests
		sandbox_linux_unittests
		wayland_client_integration_tests
		wayland_client_perftests
		wayland_hdr_client
	)

	if use vaapi || use v4l2_codec; then
		TEST_FILES+=(
			image_processor_test
			jpeg_encode_accelerator_unittest
			video_decode_accelerator_perf_tests
			video_decode_accelerator_tests
			video_encode_accelerator_perf_tests
			video_encode_accelerator_tests
		)
	fi

	if use vaapi; then
		TEST_FILES+=(
			decode_test
			vaapi_unittest
		)
	fi

	if use v4l2_codec; then
		TEST_FILES+=(
			image_processor_perf_test
			v4l2_stateless_decoder
			v4l2_unittest
		)
	fi

	if use crosier_binary; then
		TEST_FILES+=(
			chromeos_integration_tests
			fake_chrome
		)
	fi

	# Binaries that tests started generally depending on.
	TEST_BINARIES=(
		icudtl.dat
		resources.pak
	)

	# TODO(ihf): Figure out how to keep this in sync with telemetry.
	TOOLS_TELEMETRY_BIN=(
		bitmaptools
		clear_system_cache
		minidump_stackwalk
	)
}

# Handle all CFLAGS/CXXFLAGS/etc... munging here.
setup_compile_flags() {
	# Chrome controls its own optimization settings, so this would be a nop
	# if we were to run it. Leave it here anyway as a grep-friendly marker.
	# cros_optimize_package_for_speed

	# The chrome makefiles specify -O and -g flags already, so remove the
	# portage flags.
	filter-flags -g "-O*"

	# Remove unsupported arm64 linker flag on arm32 builds.
	# https://crbug.com/889079
	use arm && filter-flags "-Wl,--fix-cortex-a53-843419"

	# Chrome is expected to have its own sanitizer story independent of our
	# $CFLAGS. Since we set `use_asan` and similar in `args.gn`, filter any
	# sanitizers out here.
	filter-flags '-fsanitize=*' '-fsanitize-trap=*'

	if use chrome_cfi_thinlto; then
		# if using thinlto, we need to pass the equivalent of
		# -fdebug-types-section to the backend, to prevent out-of-range
		# relocations (see
		# https://bugs.chromium.org/p/chromium/issues/detail?id=1032159).
		append-ldflags -Wl,-mllvm
		append-ldflags -Wl,-generate-type-units
	else
		# Non-ThinLTO builds with symbol_level=2 may have out-of-range
		# relocations, too: crbug.com/1050819.
		append-flags -fdebug-types-section
	fi

	# Enable std::vector []-operator bounds checking.
	append-cxxflags -D__google_stl_debug_vector=1

	# Chrome and Chrome OS versions of the compiler may not be in
	# sync. So, don't complain if Chrome uses a diagnostic
	# option that is not yet implemented in the compiler version used
	# by Chrome OS.
	# Turns out this is only really supported by Clang. See crosbug.com/615466
	# Add "-faddrsig" flag required to efficiently support "--icf=all".
	append-flags -faddrsig
	append-flags -Wno-unknown-warning-option

	export CXXFLAGS_host+=" -Wno-unknown-warning-option"
	export CFLAGS_host+=" -Wno-unknown-warning-option"
	export LDFLAGS_host+=" --unwindlib=libgcc"
	if use libcxx; then
		append-cxxflags "-stdlib=libc++"
		append-ldflags "-stdlib=libc++"
	fi

	use vtable_verify && append-ldflags -fvtable-verify=preinit

	local flags
	einfo "Building with the compiler settings:"
	for flags in {C,CXX,CPP,LD}FLAGS; do
		einfo "  ${flags} = ${!flags}"
	done
}

src_configure() {
	tc-export CXX CC AR AS NM RANLIB STRIP
	export CC_host=$(tc-getBUILD_CC)
	export CXX_host=$(tc-getBUILD_CXX)
	export NM_host=$(tc-getBUILD_NM)
	export READELF="llvm-readelf"
	export READELF_host="llvm-readelf"

	# Use C++ compiler as the linker driver.
	export LD="${CXX}"
	export LD_host=${CXX_host}

	# We need below change when thinlto is enabled. We set this globally
	# so that users can turn on the "use_thin_lto" in the simplechrome
	# flow more easily.
	# use nm from llvm, https://crbug.com/917193
	export NM="llvm-nm"
	export NM_host="llvm-nm"
	export AR="llvm-ar"
	# USE=chrome_cfi_thinlto affects host build, we need to set host AR to
	# llvm-ar to make sure host package builds with thinlto.
	# crbug.com/731335
	export AR_host="llvm-ar"
	export RANLIB="llvm-ranlib"
	# Use llvm's objcopy instead of GNU
	export OBJCOPY="llvm-objcopy"

	# Set binutils path for remoteexec.
	CFLAGS_host+=" -B$(get_binutils_path "${LD_host}")"
	CXXFLAGS_host+=" -B$(get_binutils_path "${LD_host}")"

	setup_compile_flags

	# We might set BOTO_CONFIG in the builder environment in case the
	# existing file needs modifications (e.g. for working with older
	# branches). So don't overwrite it if it's already set.
	# See https://crbug.com/847676 for details.
	export BOTO_CONFIG="${BOTO_CONFIG:-/home/$(whoami)/.boto}"
	export PATH=${PATH}:${DEPOT_TOOLS}

	export DEPOT_TOOLS_GSUTIL_BIN_DIR="${CHROME_CACHE_DIR}/gsutil_bin"

	if [[ "${CHROME_ORIGIN}" == "SERVER_SOURCE" ]]; then
		# Lock the destination directory to avoid having multiple ebuilds writing
		# to the same directory concurrently.
		local cmd=( flock "${CHROME_ROOT}" "${EGCLIENT}" runhooks --force )
		echo "${cmd[@]}"
		"${cmd[@]}" || die
	fi

	local usr_bin="/usr/bin/"

	BUILD_STRING_ARGS+=(
		"cros_target_ar=${AR}"
		"cros_target_cc=${usr_bin}${CC}"
		"cros_target_cxx=${usr_bin}${CXX}"
		"host_toolchain=//build/toolchain/cros:host"
		"custom_toolchain=//build/toolchain/cros:target"
		"v8_snapshot_toolchain=//build/toolchain/cros:v8_snapshot"
		"cros_target_ld=${LD}"
		"cros_target_nm=${NM}"
		"cros_target_readelf=${READELF}"
		"cros_target_extra_cflags=${CFLAGS}"
		"cros_target_extra_cppflags=${CPPFLAGS}"
		"cros_target_extra_cxxflags=${CXXFLAGS}"
		"cros_target_extra_ldflags=${LDFLAGS}"
		"cros_host_cc=${usr_bin}${CC_host}"
		"cros_host_cxx=${usr_bin}${CXX_host}"
		"cros_host_ar=${AR_host}"
		"cros_host_ld=${LD_host}"
		"cros_host_nm=${NM_host}"
		"cros_host_readelf=${READELF_host}"
		"cros_host_extra_cflags=${CFLAGS_host}"
		"cros_host_extra_cxxflags=${CXXFLAGS_host}"
		"cros_host_extra_cppflags=${CPPFLAGS_host}"
		"cros_host_extra_ldflags=${LDFLAGS_host}"
		"cros_v8_snapshot_cc=${usr_bin}${CC_host}"
		"cros_v8_snapshot_cxx=${usr_bin}${CXX_host}"
		"cros_v8_snapshot_ar=${AR_host}"
		"cros_v8_snapshot_ld=${LD_host}"
		"cros_v8_snapshot_nm=${NM_host}"
		"cros_v8_snapshot_readelf=${READELF_host}"
		"cros_v8_snapshot_extra_cflags=${CFLAGS_host}"
		"cros_v8_snapshot_extra_cxxflags=${CXXFLAGS_host}"
		"cros_v8_snapshot_extra_cppflags=${CPPFLAGS_host}"
		"cros_v8_snapshot_extra_ldflags=${LDFLAGS_host}"
	)
	if use nacl && use arm64; then
		# Flags for building 32-bit NaCl on ARM64.
		BUILD_STRING_ARGS+=(
			"cros_nacl_helper_arm32_ar=llvm-ar"
			"cros_nacl_helper_arm32_cc=armv7a-cros-linux-gnueabihf-clang"
			"cros_nacl_helper_arm32_cxx=armv7a-cros-linux-gnueabihf-clang++"
			"cros_nacl_helper_arm32_ld=armv7a-cros-linux-gnueabihf-clang++"
			"cros_nacl_helper_arm32_readelf=llvm-readelf"
			"cros_nacl_helper_arm32_sysroot=/usr/armv7a-cros-linux-gnueabihf"
		)
	fi

	local arg
	for arg in "${BUILD_STRING_ARGS[@]}"; do
		BUILD_ARGS+=("${arg%%=*}=\"${arg#*=}\"")
	done
	export GN_ARGS="${BUILD_ARGS[*]}"
	einfo "GN_ARGS = ${GN_ARGS}"
	local gn=(
		"${CHROME_ROOT}/src/buildtools/linux64/gn" gen
		"${CHROME_ROOT}/src/${BUILD_OUT_SYM}/${BUILDTYPE}"
		--args="${GN_ARGS}" --root="${CHROME_ROOT}/src"
	)
	echo "${gn[@]}"
	"${gn[@]}" || die "Running gn for chrome failed."

	if use camera_angle_backend; then
		for arg in "${ANGLE_BUILD_ARGS[@]}"; do
			BUILD_ARGS+=("${arg%%=*}=${arg#*=}")
		done
		export ANGLE_GN_ARGS="${BUILD_ARGS[*]}"
		einfo "ANGLE_GN_ARGS = ${ANGLE_GN_ARGS}"
		local gn=(
			"${CHROME_ROOT}/src/buildtools/linux64/gn" gen
			"${CHROME_ROOT}/src/${ANGLE_BUILD_OUT_SYM}/${BUILDTYPE}"
			--args="${ANGLE_GN_ARGS}" --root="${CHROME_ROOT}/src"
			--root-target="//third_party/angle"
		)
		echo "${gn[@]}"
		"${gn[@]}" || die "Running gn for angle failed."
	fi

	setup_test_lists

	if use clang_tidy; then
		export WITH_TIDY=1
	fi
}

chrome_make() {
	local build_dir="$1"
	shift

	# If ThinLTO is enabled, we may have a cache from a previous link. Due
	# to fears about lack of reproducibility, we don't allow cache reuse
	# across rebuilds. The cache is still useful for artifacts shared
	# between multiple links done by this build (e.g. tests).
	use chrome_cfi_thinlto && rm -rf "${build_dir}/thinlto-cache"

	local parallelism="$(makeopts_jobs)"
	# For slow remoteexec builds, decrease the number of parallel
	# run to 10 * {number of processors}. Though, if it is too large the
	# performance gets slow down, so limit by 200 heuristically.
	# For any other remoteexec build, the parallelism  level is
	# set in cros-remoteexec.eclass.
	if cros-remoteexec_use_remoteexec && use chrome_cfi_thinlto; then
		local num_parallel=$(($(nproc) * 10))
		local j_limit=200
		parallelism=$((num_parallel < j_limit ? num_parallel : j_limit))
	fi
	local command=(
		"${ENINJA}"
		-j "${parallelism}"
		-C "${build_dir}"
		$(usex verbose -v "")
		-d "keeprsp"
		"$@"
	)

	# If remoteexec is used, log the command, cwd and env vars
	if cros-remoteexec_use_remoteexec; then
		# shellcheck disable=SC2154 # RBE_log_dir declared in cros-remoteexec.eclass
		env --null > "${RBE_log_dir}/ninja_env" || die
		pwd > "${RBE_log_dir}/ninja_cwd" || die
		echo "${command[@]}" > "${RBE_log_dir}/ninja_command" || die
	fi
	PATH=${PATH}:${DEPOT_TOOLS} "${command[@]}"
	local ret=$?
	if cros-remoteexec_use_remoteexec; then
		echo "${ret}" > "${RBE_log_dir}/ninja_exit"
		cp -p "${build_dir}/.ninja_log" \
			"${RBE_log_dir}/ninja_log" || die
	fi
	[[ "${ret}" -eq 0 ]] || die
}

src_compile() {
	if [[ "${CHROME_ORIGIN}" != "LOCAL_SOURCE" &&
			"${CHROME_ORIGIN}" != "SERVER_SOURCE" ]]; then
		return
	fi

	cd "${CHROME_ROOT}"/src || die "Cannot chdir to ${CHROME_ROOT}/src"

	local chrome_targets=( $(usex mojo "mojo_shell" "") )
	if use app_shell; then
		chrome_targets+=( app_shell )
	else
		chrome_targets+=( chrome )
	fi
	if use build_tests; then
		chrome_targets+=(
			"${TEST_FILES[@]}"
			"${TOOLS_TELEMETRY_BIN[@]}"
			chromedriver
		)
		if use chrome_internal; then
			chrome_targets+=( libassistant_debug.so )
		fi
	fi
	use_nacl && chrome_targets+=( nacl_helper_bootstrap nacl_helper )

	chrome_make "${BUILD_OUT_SYM}/${BUILDTYPE}" "${chrome_targets[@]}"

	if use camera_angle_backend; then
		chrome_make "${ANGLE_BUILD_OUT_SYM}/${BUILDTYPE}" "angle"
	fi

	if use build_tests; then
		install_chrome_test_resources "${WORKDIR}/test_src"
		install_telemetry_dep_resources "${WORKDIR}/telemetry_src"

		# NOTE: Since chrome is built inside distfiles, we have to get
		# rid of the previous instance first.
		# We remove only what we will overwrite with the mv below.
		local deps="${WORKDIR}/${P}/${AUTOTEST_DEPS}"

		rm -rf "${deps}/chrome_test/test_src"
		mv "${WORKDIR}/test_src" "${deps}/chrome_test/" || die

		rm -rf "${deps}/telemetry_dep/test_src"
		mv "${WORKDIR}/telemetry_src" "${deps}/telemetry_dep/test_src" \
			|| die

		# The autotest eclass wants this for some reason.
		get_paths() { :; }

		# HACK: It would make more sense to call autotest_src_prepare in
		# src_prepare, but we need to call install_chrome_test_resources first.
		autotest-deponly_src_prepare

		# Remove .git dirs
		# shellcheck disable=SC2154 # this is a bug in the linter.
		find "${AUTOTEST_WORKDIR}" -type d -name .git -prune \
			-exec rm -rf {} + || die

		autotest_src_compile
	fi

	cros-remoteexec_shutdown
}

install_test_resources() {
	# Install test resources from chrome source directory to destination.
	# We keep a cache of test resources inside the chroot to avoid copying
	# multiple times.
	local test_dir="${1}"
	einfo "install_test_resources to ${test_dir}"
	shift

	# To speed things up, we write the list of files to a temporary file so
	# we can use rsync with --files-from.
	local tmp_list_file="${T}/${test_dir##*/}.files"
	printf "%s\n" "$@" > "${tmp_list_file}" || die

	# Copy the specific files to the cache from the source directory.
	# Note: we need to specify -r when using --files-from and -a to get a
	# recursive copy.
	rsync -r -a --delete --exclude=.git --exclude="*.pyc" \
		--files-from="${tmp_list_file}" "${CHROME_ROOT}/src/" \
		"${CHROME_CACHE_DIR}/src/" || die

	# Sync files to the destination based on the cache.
	# Note: we need to specify -r when using --files-from and -a to get a
	# recursive copy.
	rsync -r -a --files-from="${tmp_list_file}" "${CHROME_CACHE_DIR}/src/" \
		"${test_dir}/" || die
}

test_binary_install() {
	local from="${1}"
	local dest="${2}"
	shift 2
	mkdir -p "${dest}" || die
	local f
	for f in "$@"; do
		cp "${from}/${f}" "${dest}/$(basename "${f}")" || die
	done
}

test_strip_install() {
	local from="${1}"
	local dest="${2}"
	shift 2
	mkdir -p "${dest}" || die
	local f
	for f in "$@"; do
		$(tc-getSTRIP) --strip-debug \
			"${from}/${f}" -o "${dest}/$(basename "${f}")" || die
	done
}

install_chrome_test_resources() {
	# NOTE: This is a duplicate from src_install, because it's required here.
	local from="${CHROME_CACHE_DIR}/src/${BUILD_OUT}/${BUILDTYPE}"
	local test_dir="${1}"
	local dest="${test_dir}/out/Release"

	echo Copying Chrome tests into "${test_dir}"

	# Even if chrome_debug_tests is enabled, we don't need to include detailed
	# debug info for tests in the binary package, so save some time by stripping
	# everything but the symbol names. Developers who need more detailed debug
	# info on the tests can use the original unstripped tests from the ${from}
	# directory.
	local test_install_targets=( "${TEST_FILES[@]}" )
	einfo "Installing test targets: ${test_install_targets[*]}"
	test_strip_install "${from}" "${dest}" "${test_install_targets[@]}"

	# Binaries that are in the out directory and can't be stripped.
	test_binary_install "${from}" "${dest}" "${TEST_BINARIES[@]}"

	# Install Chrome test resources.
	# WARNING: Only install subdirectories of |chrome/test|.
	# The full |chrome/test| directory is huge and kills our VMs.
	install_test_resources "${test_dir}" \
		base/base_paths_posix.cc \
		chrome/test/data/chromeos \
		media/test/data \
		content/test/data \
		net/data/ssl/certificates \
		ppapi/tests/test_case.html \
		ppapi/tests/test_url_loader_data

	# Add the pdf test data if needed.
	if use chrome_internal; then
		install_test_resources "${test_dir}" pdf/test
	fi
	# Add the gles_conform test data if needed.
	if use chrome_internal || use internal_gles_conform; then
		install_test_resources "${test_dir}" gpu/gles2_conform_support/gles2_conform_test_expectations.txt
	fi

	cp -a "${CHROME_ROOT}"/"${AUTOTEST_DEPS}"/chrome_test/setup_test_links.sh \
		"${dest}" || die

	if use crosier_binary; then
		einfo "Copying Crosier test dependencies from: ${CHROME_ROOT}/src and ${from} to ${dest}"
		cp -a -r -f "${CHROME_ROOT}"/src/chrome/test/base/chromeos/crosier/helper/test_sudo_helper.py \
			"${CHROME_ROOT}"/src/chrome/test/base/chromeos/crosier/helper/reset_dut.py \
			"${CHROME_ROOT}"/src/chrome/test/data/chromeos/web_handwriting \
			"${CHROME_ROOT}"/src/third_party/test_fonts \
			"${from}/crosier_metadata" \
			"${dest}" || die
		if use chrome_internal; then
			cp -a -f "${CHROME_ROOT}/src/chrome/browser/internal/resources/chromeos/crosier/test_accounts.json" "${dest}" || die
		fi
		einfo "Crosier test dependencies copied successfully"
	fi
}

install_telemetry_dep_resources() {
	local test_dir="${1}"

	local telemetry=${CHROME_ROOT}/src/third_party/catapult/telemetry
	if [[ -r "${telemetry}" ]]; then
		echo "Copying Telemetry Framework into ${test_dir}"
		mkdir -p "${test_dir}" || die
		# We are going to call chromium code but can't trust that it is clean
		# of precompiled code. See crbug.com/590762.
		find "${telemetry}" -name "*.pyc" -type f -delete || die
		# Get deps from Chrome.
		local find_deps=${CHROME_ROOT}/src/tools/perf/find_dependencies
		local perf_deps=${CHROME_ROOT}/src/tools/perf/bootstrap_deps
		local cros_deps=${CHROME_ROOT}/src/tools/cros/bootstrap_deps
		# sed removes the leading path including src/ converting it to relative.
		# To avoid silent failures assert the success.
		local deps_list=$(${find_deps} "${perf_deps}" "${cros_deps}" | \
			sed -e "s|^${CHROME_ROOT}/src/||"; assert)
		install_test_resources "${test_dir}" "${deps_list}"
	fi

	local from="${CHROME_CACHE_DIR}/src/${BUILD_OUT}/${BUILDTYPE}"
	local dest="${test_dir}/src/out/${BUILDTYPE}"
	einfo "Installing telemetry binaries: ${TOOLS_TELEMETRY_BIN[*]}"
	test_strip_install "${from}" "${dest}" "${TOOLS_TELEMETRY_BIN[@]}"

	# When copying only a portion of the Chrome source that telemetry needs,
	# some symlinks can end up broken. Thus clean these up before packaging.
	einfo "Cleaning up broken symlinks in telemetry"
	find -L "${test_dir}" -type l -delete || die

	# Unfortunately we are sometimes provided with unrelated upstream directories
	# and binaries taking a lot of space. Clean these up manually. Notice
	# that Android and Linux directories might be needed so keep those.
	einfo "Cleaning up non-Chrome OS directories in telemetry"
	find -L "${test_dir}" -type d -regex ".*/\(mac\|mips\|mips64\|win\)" \
		-exec rm -rfv {} \;
	einfo "Finished installing telemetry dep resources"
}

# Add any new artifacts generated by the Chrome build targets to deploy_chrome.py.
# We deal with miscellaneous artifacts here in the ebuild.
src_install() {
	local from="${CHROME_CACHE_DIR}/src/${BUILD_OUT}/${BUILDTYPE}"

	# Override default strip flags and lose the '-R .comment'
	# in order to play nice with the crash server.
	if [[ -z "${KEEP_CHROME_DEBUG_SYMBOLS}" ]]; then
		if [[ "$(tc-getSTRIP)" == "llvm-strip" ]]; then
			export PORTAGE_STRIP_FLAGS="--strip-all-gnu"
		else
			export PORTAGE_STRIP_FLAGS=""
		fi
	else
		export PORTAGE_STRIP_FLAGS="--strip-debug"
	fi
	einfo "PORTAGE_STRIP_FLAGS=${PORTAGE_STRIP_FLAGS}"
	local ls=$(ls -alhS "${from}") || die
	einfo "CHROME_DIR after build\n${ls}"

	insinto /etc/init
	doins "${FILESDIR}"/mount-ash-chrome.conf

	# Copy a D-Bus config file that includes other configs that are installed to
	# /opt/google/chrome/dbus by deploy_chrome.
	insinto /etc/dbus-1/system.d
	doins "${FILESDIR}"/chrome.conf

	# Chrome test resources
	# Test binaries are only available when building chrome from source
	if use build_tests && [[ "${CHROME_ORIGIN}" == "LOCAL_SOURCE" ||
		"${CHROME_ORIGIN}" == "SERVER_SOURCE" ]]; then
		autotest-deponly_src_install
		#env -uRESTRICT prepstrip "${D}${AUTOTEST_BASE}"

		# Copy input_methods.txt for auto-test.
		insinto /usr/share/chromeos-assets/input_methods
		doins "${CHROME_ROOT}"/src/chromeos/ime/input_methods.txt
	fi

	# Fix some perms.
	# TODO(rcui): Remove this - shouldn't be needed, and is just covering up
	# potential permissions bugs.
	chmod -R a+r "${D}" || die
	find "${D}" -perm /111 -print0 | xargs -0 chmod a+x

	# The following symlinks are needed in order to run chrome.
	# TODO(rcui): Remove this.  Not needed for running Chrome.
	dosym libnss3.so /usr/lib/libnss3.so.1d
	dosym libnssutil3.so.12 /usr/lib/libnssutil3.so.1d
	dosym libsmime3.so.12 /usr/lib/libsmime3.so.1d
	dosym libssl3.so.12 /usr/lib/libssl3.so.1d
	dosym libplds4.so /usr/lib/libplds4.so.0d
	dosym libplc4.so /usr/lib/libplc4.so.0d
	dosym libnspr4.so /usr/lib/libnspr4.so.0d

	# Create the main Chrome install directory.
	dodir "${CHROME_DIR}"
	insinto "${CHROME_DIR}"

	# Use the deploy_chrome from the *Chrome* checkout.  The benefit of
	# doing this is if a new buildspec of Chrome requires a non-backwards
	# compatible change to deploy_chrome, we can commit the fix to
	# deploy_chrome without breaking existing Chrome OS release builds,
	# and then roll the DEPS for chromite in the Chrome checkout.
	#
	# Another benefit is each version of Chrome will have the right
	# corresponding version of deploy_chrome.
	local cmd=( "${CHROME_ROOT}"/src/third_party/chromite/bin/deploy_chrome )
	# Disable stripping for now, as deploy_chrome doesn't generate splitdebug files.
	cmd+=(
		"--board=${BOARD}"
		"--build-dir=${from}"
		"--gn-args=${GN_ARGS}"
		# If this is enabled, we need to re-enable `prepstrip` above for autotests.
		# You'll also have to re-add "strip" to the RESTRICT at the top of the file.
		--nostrip
		"--staging-dir=${D_CHROME_DIR}"
		"--staging-flags=${USE}"
		--staging-only
		"--strip-bin=${STRIP}"
		"--strip-flags=${PORTAGE_STRIP_FLAGS}"
		--verbose
	)
	if use compressed_ash; then
		cmd+=(--compressed-ash)
	fi
	einfo "${cmd[*]}"
	"${cmd[@]}" || die
	ls=$(ls -alhS "${D}/${CHROME_DIR}")
	einfo "CHROME_DIR after deploy_chrome\n${ls}"

	# Do not strip the debug files.
	dostrip -x "/usr/lib/debug/"

	# Keep the .dwp files with debug fission.
	if use chrome_debug && use debug_fission; then
		mkdir -p "${D}/usr/lib/debug/${CHROME_DIR}" || die
		cd "${D}/${CHROME_DIR}" || die
		# Iterate over all ELF files in current directory
		while read -r i; do
			cd "${from}" || die
			# These files do not build with -gsplit-dwarf,
			# so we do not need to get a .dwp file from them.
			if [[ "${i}" == "./nacl_helper_nonsfi"	|| \
				"${i}" == "./nacl_helper_bootstrap"	|| \
				"${i}" == "./nacl_irt_arm.nexe"		|| \
				"${i}" == "./nacl_irt_x86_64.exe"	|| \
				"${i}" == "./nacl_irt_x86_64.nexe"	|| \
				"${i}" == "./libmojo_core_arc64.so"	|| \
				"${i}" == "./libmojo_core_arc32.so"	|| \
				"${i}" == "./libwidevinecdm.so" ]] ; then
				continue
			fi
			# Same for nacl_helper, though only on arm64.
			[[ "${ARCH}" == "arm64" && "${i}" == "./nacl_helper" ]] && continue
			local source="${i}"
			# shellcheck disable=SC2154
			${DWP} -e "${from}/${source}" -o "${D}/usr/lib/debug/${CHROME_DIR}/${i}.dwp" || die
		done < <(scanelf -ByF '%F' ".")
	fi

	if use build_tests; then
		# Install Chrome Driver to test image.
		local chromedriver_dir='/usr/local/chromedriver'
		dodir "${chromedriver_dir}"
		cp -pPR "${from}"/chromedriver "${D}/${chromedriver_dir}" || die

		if use chrome_internal; then
			# Install LibAssistant test library to test image.
			into /usr/local/
			dolib.so "${from}"/libassistant_debug.so
		fi

		# Install a testing script to run Lacros from command line.
		into /usr/local
		dobin "${CHROME_ROOT}"/src/build/lacros/mojo_connection_lacros_launcher.py
	fi

	if use chrome_internal; then
		# Copy LibAssistant V2 library to a temp build folder for later
		# installation of `assistant-dlc`.
		exeinto /build/share/libassistant
		doexe "${from}/libassistant_v2.so"
	fi

	# The icu data is used by both chromeos-base/chrome-icu and this package.
	# chromeos-base/chrome-icu is responsible for installing the icu
	# data, so we remove it from ${D} here.
	rm "${D_CHROME_DIR}/icudtl.dat" || die
	rm "${D_CHROME_DIR}/icudtl.dat.hash" || die

	if use camera_angle_backend; then
		local from="${CHROME_CACHE_DIR}/src/${ANGLE_BUILD_OUT}/${BUILDTYPE}"

		# For now install in private directory.
		dodir "/usr/$(get_libdir)/angle"
		insinto "/usr/$(get_libdir)/angle"

		insopts -m0755
		doins "${from}/libEGL.so"
		doins "${from}/libGLESv2.so"
	fi
}

pkg_preinst() {
	enewuser "wayland"
	enewgroup "wayland"
	local ls=$(ls -alhS "${ED}/${CHROME_DIR}")
	einfo "CHROME_DIR after installation\n${ls}"
	local chrome_size=$(stat --printf="%s" "${ED}/${CHROME_DIR}/chrome")
	einfo "chrome_size = ${chrome_size}"

	# Non-internal builds come with >10MB of unwinding info built-in. Size
	# checks on those are less profitable.
	if [[ ${chrome_size} -ge 300000000 && -z "${KEEP_CHROME_DEBUG_SYMBOLS}" ]] && use chrome_internal && ! use chrome_dcheck; then
		die "Installed chrome binary got suspiciously large (size=${chrome_size})."
	fi
	if use arm; then
		local files=$(find "${ED}/usr/lib/debug${CHROME_DIR}" -size +$((4 * 1024 * 1024 * 1024 - 1))c)
		[[ -n ${files} ]] && die "Debug files exceed 4GiB: ${files}"
	fi
	# Verify that the elf program headers in splitdebug binary match the chrome
	# binary, this is needed for correct symbolization in CWP.
	# b/128861198, https://crbug.com/1007548 .
	if [[ ${MERGE_TYPE} != binary ]] && use strict_toolchain_checks; then
		local chrome_headers=$(${READELF} --program-headers --wide \
			"${ED}/${CHROME_DIR}"/chrome | grep LOAD)
		local chrome_debug_headers=$(${READELF} --program-headers --wide \
			"${ED}/usr/lib/debug${CHROME_DIR}"/chrome.debug | grep LOAD)
		[[ "${chrome_headers}" != "${chrome_debug_headers}" ]] && \
			die "chrome program headers do not match chrome.debug"
	fi
}

pkg_postinst() {
	autotest_pkg_postinst
}
