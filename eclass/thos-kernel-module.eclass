# Copyright (c) 2022 Fyde Innovations Limited and the openFyde Authors.
# Distributed under the license specified in the root directory of this project.

inherit linux-info linux-mod
LICENSE="GPL-2"
SLOT="0"
DEPEND="virtual/linux-sources"

RDEPEND="${DEPEND}"

IUSE="
  kernel-3_18
  kernel-4_14
  kernel-4_19
  kernel-5_4
  kernel-5_10
  clang
"

EXPORT_FUNCTIONS pkg_setup

fydeos-kernel-module_pkg_setup() {
  if use kernel-4_14; then
    export KERNEL_DIR="/mnt/host/source/src/third_party/kernel/v4.14"
  fi
  if use kernel-4_19; then
    export KERNEL_DIR="/mnt/host/source/src/third_party/kernel/v4.19"
  fi
  if use kernel-5_4; then
    export KERNEL_DIR="/mnt/host/source/src/third_party/kernel/v5.4"
  fi
  if use kernel-5_10; then
    export KERNEL_DIR="/mnt/host/source/src/third_party/kernel/v5.10"
  fi

  export KBUILD_OUTPUT=${ROOT}usr/src/linux
  export KV_OUT_DIR=${ROOT}usr/src/linux 
  einfo KBUILD_OUTPUT:$KBUILD_OUTPUT
  local makefile=${KV_OUT_DIR}/Makefile
  if [ -z "$(cat $makefile| grep ${KERNEL_DIR})" ]; then
    einfo rewrite $makefile
    pushd ${KV_OUT_DIR}
    ${KERNEL_DIR}/scripts/mkmakefile ${KERNEL_DIR}
    popd
  fi
  linux-mod_pkg_setup
}
