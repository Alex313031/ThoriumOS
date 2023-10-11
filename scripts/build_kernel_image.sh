#!/bin/bash

# Copyright 2023 The ChromiumOS Authors and Alex313031
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# All kernel command line changes must update the security base lines in
# the signer.  It rejects any settings it does not recognize and breaks the
# build.  So any modify_kernel_command_line() function change here needs to be
# reflected in ensure_secure_kernelparams.config.

# See crrev.com/i/216896 as an example.

# The following kernel cmdline paramaters were added to ThoriumOS
# to more closely match ChromeOS Flex, to enable running Crostini
# on more devices with older CPUs.
modify_kernel_command_line() {

  # Enable modules from outside the root FS, and out of tree modules.
  echo "lsm.module_locking=0" >> "$1"

  # Don't disable the ability to run VMs.
  echo "disablevmx=off" >> "$1"

  # Mitigate risk from running untrusted VMs.
  echo "kvm-intel.vmentry_l1d_flush=always" >> "$1"

}
