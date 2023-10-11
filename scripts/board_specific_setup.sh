#!/bin/bash

# Copyright 2023 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# This will add console=ttyAMA0 kernel cmdline flag, thus rerouting
# dmesg output to ttyAMA0 (serial port).
# FLAGS_enable_serial=ttyAMA0

skip_blacklist_check=1
FLAGS_boot_args="${FLAGS_boot_args} audit=0"
