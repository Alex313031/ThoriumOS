#!/bin/sh
SWITCHER="/sys/kernel/debug/vgaswitcheroo/switch"
INTEL="IGD"

switch_to_intel() {
  if [ -d ${SWITCHER} ]; then
    echo $INTEL > $SWITCHER
  fi  
}

switch_to_intel
