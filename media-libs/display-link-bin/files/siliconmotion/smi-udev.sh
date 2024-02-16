#!/bin/sh
# Copyright (c) 2018 -2020 SiliconMotion Inc.

# Get the smiusbdisplay device count.
get_smiusbdisplay_dev_count() {
  cat /sys/bus/usb/devices/*/manufacturer  | grep "Silicon_Motion" -c
}

# Start the smiusbdisplay service.
start_smiusbdisplay() {
  if [ "$(get_smiusbdisplay_dev_count)" != "0" ]; then
	start_service
  fi
}

# Stop the smiusbdisplay service when there is no SMI device.
stop_smiusbdisplay() {
  if [ "$(get_smiusbdisplay_dev_count)" = "0" ]; then
    stop_service
  fi
}

# Evdi can be a built-in or not.
build_in_EVDI() {
  local EVDI_ADD="/sys/devices/evdi/add"

  modprobe evdi || true
  # Allow smdisplay (in video group) write to evdi/add.
  chgrp video "${EVDI_ADD}"
  chmod g+w "${EVDI_ADD}"
}

main() {
  local action="$1"
  local root="$2"

  if [ "${action}" = "add" ]; then
    build_in_EVDI
    start_smiusbdisplay
  elif [ "${action}" = "remove" ]; then
    stop_smiusbdisplay "${root}"
  elif [ "${action}" = "START" ]; then
    build_in_EVDI
    start_smiusbdisplay
  else
    echo "Invalid action."
    return
  fi
}

# Start the service.
start_service() {
  start smi-usbdisplay
}

# Stop the service.
stop_service() {
  stop smi-usbdisplay
}

action="$1"
root="$2"

main "${action}" "${root}"
