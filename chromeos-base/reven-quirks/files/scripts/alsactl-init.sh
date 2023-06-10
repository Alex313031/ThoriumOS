#!/bin/sh
# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
/sbin/minijail0 -v -d -b /dev/snd -n -l -p --uts -e -u nobody -g audio \
    -S /usr/share/policy/alsactl-init-seccomp.policy \
    -- /usr/sbin/alsactl init "${1}"
ret=$?
# alsactl init returns 99 on a successful default init
if [ "${ret}" -eq 99 ]; then
   exit 0
fi
exit "${ret}"
