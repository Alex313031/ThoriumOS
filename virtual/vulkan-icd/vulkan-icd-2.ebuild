# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# This package indicates the presence of a Vulkan ICD. We need this ebuild
# because libvulkan.so (provided by media-libs/vulkan-loader) does not provide
# a Vulkan implementation. It is merely a loader library for the ICDs, which
# provide the actual implementation.

EAPI="7"

DESCRIPTION="Virtual for presence of a Vulkan ICD (Installable Client Driver)"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="*"
IUSE=""

# Include the Vulkan loader as a dependency because an ICD is typically not
# useful without it. A Vulkan client can use an ICD directly, without a loader,
# only if (a) the ICD statically exposes its Vulkan entrypoints (most ICDs
# don't) or (b) the client itself implements the loader interface.
RDEPEND="
	media-libs/vulkan-loader
	media-libs/mesa-reven[vulkan]
"
DEPEND=""
