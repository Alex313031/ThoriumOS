#!/bin/bash

# Copyright (c) 2024 Alex313031.

YEL='\033[1;33m' # Yellow
CYA='\033[1;96m' # Cyan
RED='\033[1;31m' # Red
GRE='\033[1;32m' # Green
c0='\033[0m' # Reset Text
bold='\033[1m' # Bold Text
underline='\033[4m' # Underline Text

# Error handling
yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "${RED}Failed $*"; }

printf "\n" &&
printf "${YEL}Cleaning overlay-amd-frick overlay dir...${c0}\n" &&

rm -r -v ~/chromiumos/src/overlays/overlay-amd64-frick &&

printf "\n" &&
printf "${GRE}Done!\n" &&
printf "\n" &&
printf "${YEL}NOTE: You should run ./setup.sh now.\n" &&
printf "\n" &&
tput sgr0
