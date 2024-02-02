# Copyright 2024 The ChromiumOS Authors and Alex313031
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
# $Header: $

# @ECLASS: appid.eclass
# @MAINTAINER:
# ChromiumOS Build Team
# @BUGREPORTS:
# Please report bugs via http://crbug.com/new (with label Build)
# @VCSURL: https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/HEAD/eclass/@ECLASS@
# @BLURB: Eclass for setting up the omaha appid and devicetype fields in /etc/lsb-release

# @FUNCTION: doappid
# @USAGE: <appid> <devicetype>
# @DESCRIPTION:
# Initializes /etc/lsb-release with the appid and devicetype.  Note that appid
# is really just a UUID in the canonical {8-4-4-4-12} format (all uppercase).
# e.g. {01234567-89AB-CDEF-0123-456789ABCDEF}.
#
# This also adds the devicetype field, which can be one of the following values:
# - CHROMEBIT
# - CHROMEBASE
# - CHROMEBOOK
# - CHROMEBOX
# - REFERENCE
# - OTHER
doappid() {
	[[ $# -eq 3 && -n $1 && -n $2 && -n $3 ]] ||
		die "Usage: ${FUNCNAME} <appid> <devicetype>"
	[[ $2 == CHROMEBIT || $2 == CHROMEBASE || $2 == CHROMEBOOK ||
		$2 == CHROMEBOX || $2 == REFERENCE || $2 == OTHER ]] ||
		die "Usage: ${FUNCNAME} <appid> <devicetype>, where <devicetype> is one of \
CHROMEBIT, CHROMEBASE, CHROMEBOOK, CHROMEBOX, REFERENCE, OTHER (not $2)"
	local appid=$1
	local devicetype=$2

	# Validate the UUID is formatted correctly.
	local uuid_regex='[{][0-9A-F]{8}-([0-9A-F]{4}-){3}[0-9A-F]{12}[}]'
	local filtered_appid=$(echo "${appid}" | LC_ALL=C sed -r "s:${uuid_regex}::")
	if [[ -n ${filtered_appid} ]] ; then
		eerror "Invalid appid: ${appid} -> ${filtered_appid}"
		eerror "  - must start with '{' and end with '}'"
		eerror "  - must be all upper case"
		eerror "  - be a valid UUID (8-4-4-4-12 hex digits)"
		die "invalid appid: ${appid}"
	fi

	dodir /etc

	local lsb="${D}/etc/lsb-release"
	local canary_appid=$3
	[[ -e ${lsb} ]] && die "${lsb} already exists!"
	cat <<-EOF > "${lsb}" || die "creating ${lsb} failed!"
	CHROMEOS_RELEASE_APPID=${appid}
	CHROMEOS_BOARD_APPID=${appid}
	CHROMEOS_CANARY_APPID=${canary_appid}
	DEVICETYPE=${devicetype}
	EOF
}
