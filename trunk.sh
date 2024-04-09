#!/bin/bash

# Copyright (c) 2022 Alex313031 and Midzer.

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

# --help
displayHelp () {
	printf "\n" &&
	printf "${bold}${GRE}Script to Download, Rebase/Sync, Remove/Re-Download, or Delete the ChromiumOS repo on Linux.${c0}\n" &&
	printf "\n" &&
	printf "Use this script with ${bold}no${c0} flags to download the CrOS repo for the first time.\n" &&
	printf "Use the ${YEL}--rebase${c0} flag to update an existing checkout.${c0}\n" &&
	printf "Use the ${YEL}--clobber${c0} flag (Warning) to delete the chroot, CrOS repo, reset depot_tools, and re-download a fresh copy.${c0}\n" &&
	printf "  ${bold}Note:${c0} Use the ${YEL}reset_depot_tools.sh${c0} script to only reset depot_tools.${c0}\n" &&
	printf "Use the ${YEL}--delete${c0} flag (Warning) to delete the chroot and CrOS repo.${c0}\n" &&
	printf "Use ${YEL}--help${c0} to display this help message.${c0}\n" &&
	printf "\n"
	printf "  ${bold}Note:${c0} If you are building ThoriumOS, extra steps are required to build the 'chromeos-chrome' package from source ${c0}\n" &&
	printf "  with Thorium additions: See the ThoriumOS documentation for details.${c0}\n" &&
	printf "\n"
}

# --rebase
reposyncRebase () {
	printf "\n" &&
	printf "${bold}${GRE}Running with the --rebase flag.${c0}\n" &&
	printf "\n" &&
	printf "${YEL}Rebasing/Syncing and running hooks...\n" &&
	tput sgr0 &&
	
	cd ~/chromiumos &&
	
	repo status &&
	
	repo sync -j4 &&
	
	printf "${YEL}Done Rebasing!\n" &&
	printf "\n" &&
	tput sgr0 &&

	c0='\033[0m' # Reset Text
	c1='\033[0m\033[36m\033[1m' # Light Cyan
	c2='\033[0m\033[1;31m' # Light Red
	c3='\033[0m\033[37m' # Light Grey
	c4='\033[0m\033[1;34m\033[1m' # Light Blue
	c5='\033[0m\033[1;37m' # White
	c6='\033[0m\033[1;34m' # Dark Blue
	c7='\033[1;32m' # Green
	
	printf "\n" &&
	printf "${c4}                .,:loool:,.              \n" &&
	printf "${c4}            .,coooooooooooooc,.          \n" &&
	printf "${c4}         .,lllllllllllllllllllll,.       \n" &&
	printf "${c4}        ;ccccccccccccccccccccccccc;      \n" &&
	printf "${c1}      ,${c4}ccccccccccccccccccccccccccccc.    \n" &&
	printf "${c1}     ,oo${c4}c::::::::ok${c5}00000${c3}OOkkkkkkkkkkk:   \n" &&
	printf "${c1}    .ooool${c4};;;;:x${c5}K0${c6}kxxxxxk${c5}0X${c3}K0000000000.  \n" &&
	printf "${c1}    :oooool${c4};,;O${c5}K${c6}ddddddddddd${c5}KX${c3}000000000d  \n" &&
	printf "${c1}    lllllool${c4};l${c5}N${c6}dllllllllllld${c5}N${c3}K000000000  \n" &&
	printf "${c1}    lllllllll${c4}o${c5}M${c6}dccccccccccco${c5}W${c3}K000000000  \n" &&
	printf "${c1}    ;cllllllllX${c5}X${c6}c:::::::::c${c5}0X${c3}000000000d  \n" &&
	printf "${c1}    .ccccllllllO${c5}Nk${c6}c;,,,;cx${c5}KK${c3}0000000000.  \n" &&
	printf "${c1}     .cccccclllllxO${c5}OOOO0${c1}kx${c3}O0000000000;   \n" &&
	printf "${c1}      .:ccccccccllllllllo${c3}O0000000OOO,    \n" &&
	printf "${c1}        ,:ccccccccclllcd${c3}0000OOOOOOl.     \n" &&
	printf "${c1}          .::ccccccccc${c3}dOOOOOOOkx:.       \n" &&
	printf "${c1}            ..,::cccc${c3}xOOOkkko;.          \n" &&
	printf "${c1}               ..::${c3}dOkkxl:.              \n" &&
	printf "\n" &&
	printf "${c7}            Long Live ChromiumOS\041\n${c0}\n"
}

# --clobber
reposyncClobber () {
	
	printf "\n" &&
	printf "${bold}${RED} (Warning) Running with the --clobber flag.${c0}\n" &&
	
	read -p "Press Enter to continue, Ctrl + C to abort."
	
	printf "\n" &&
	printf "${YEL}Deleting chroot, removing ~/chromiumos, resetting depot_tools, and redownloading CrOS checkout...${c0}\n" &&
	printf "\n" &&
	
	if [ -d "~/chromiumos" ] 
then
    cd ~/chromiumos &&
	cros_sdk --delete &&
	printf "\n"
else
	printf "${YEL}~/chromiumos does not exist, continuing...${c0}\n" &&
	printf "\n"
fi &&
	cd ~/ &&
	sudo rm -r -f chromiumos &&
	sudo rm -r -f .repoconfig &&
	sudo rm -r -f .repo_.gitconfig.json &&
	sudo rm -r -f $HOME/depot_tools &&
	sudo rm -r -f $HOME/.gsutil &&
	sudo rm -r -f $HOME/.vpython_cipd_cache &&
	sudo rm -r -f $HOME/.vpython-root &&
	cd $HOME &&
	git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git &&
	source ~/.bashrc &&
	mkdir -p ~/chromiumos &&
	cd ~/chromiumos &&
	repo init -u https://chromium.googlesource.com/chromiumos/manifest -b release-R123-15786.B &&
	repo sync -j4
}

case $1 in
	--help) displayHelp; exit 0;;
esac

case $1 in
	--rebase) reposyncRebase; exit 0;;
esac

case $1 in
	--clobber) reposyncClobber; exit 0;;
esac

printf "\n" &&
printf "${bold}${GRE}Script to Download, Rebase/Sync, or Delete the ChromiumOS repo on Linux.${c0}\n" &&
printf "\n" &&
printf "${bold}${YEL}Use the ${c0}--rebase${bold}${YEL} flag to update an existing checkout.${c0}\n" &&
printf "${bold}${YEL}Use this script with no flags to download the CrOS repo for the first time.${c0}\n" &&
printf "${bold}${YEL}Use the ${c0}--clobber${bold}${YEL} flag (Warning) to delete the chroot, CrOS repo, AND reset depot_tools.${c0}\n" &&
printf "${bold}${YEL}Note: Use the ${c0}reset_depot_tools.sh${bold}${YEL} script to only reset depot_tools.${c0}\n" &&
printf "${bold}${YEL}Use ${c0}--help${bold}${YEL} to display this help message.${c0}\n" &&
printf "\n" &&

cd ~/ &&
mkdir -p ~/chromiumos &&
cd ~/chromiumos &&
repo init -u https://chromium.googlesource.com/chromiumos/manifest -b release-R123-15786.B &&
repo sync -j4 &&

printf "${YEL}Done!\n" &&
printf "\n" &&
tput sgr0 &&

c0='\033[0m' # Reset Text
c1='\033[0m\033[36m\033[1m' # Light Cyan
c2='\033[0m\033[1;31m' # Light Red
c3='\033[0m\033[37m' # Light Grey
c4='\033[0m\033[1;34m\033[1m' # Light Blue
c5='\033[0m\033[1;37m' # White
c6='\033[0m\033[1;34m' # Dark Blue
c7='\033[1;32m' # Green

printf "\n" &&
printf "${c4}                .,:loool:,.              \n" &&
printf "${c4}            .,coooooooooooooc,.          \n" &&
printf "${c4}         .,lllllllllllllllllllll,.       \n" &&
printf "${c4}        ;ccccccccccccccccccccccccc;      \n" &&
printf "${c1}      ,${c4}ccccccccccccccccccccccccccccc.    \n" &&
printf "${c1}     ,oo${c4}c::::::::ok${c5}00000${c3}OOkkkkkkkkkkk:   \n" &&
printf "${c1}    .ooool${c4};;;;:x${c5}K0${c6}kxxxxxk${c5}0X${c3}K0000000000.  \n" &&
printf "${c1}    :oooool${c4};,;O${c5}K${c6}ddddddddddd${c5}KX${c3}000000000d  \n" &&
printf "${c1}    lllllool${c4};l${c5}N${c6}dllllllllllld${c5}N${c3}K000000000  \n" &&
printf "${c1}    lllllllll${c4}o${c5}M${c6}dccccccccccco${c5}W${c3}K000000000  \n" &&
printf "${c1}    ;cllllllllX${c5}X${c6}c:::::::::c${c5}0X${c3}000000000d  \n" &&
printf "${c1}    .ccccllllllO${c5}Nk${c6}c;,,,;cx${c5}KK${c3}0000000000.  \n" &&
printf "${c1}     .cccccclllllxO${c5}OOOO0${c1}kx${c3}O0000000000;   \n" &&
printf "${c1}      .:ccccccccllllllllo${c3}O0000000OOO,    \n" &&
printf "${c1}        ,:ccccccccclllcd${c3}0000OOOOOOl.     \n" &&
printf "${c1}          .::ccccccccc${c3}dOOOOOOOkx:.       \n" &&
printf "${c1}            ..,::cccc${c3}xOOOkkko;.          \n" &&
printf "${c1}               ..::${c3}dOkkxl:.              \n" &&
printf "\n"
printf "${c7}            Long Live ChromiumOS\041\n${c0}\n" &&

exit 0
