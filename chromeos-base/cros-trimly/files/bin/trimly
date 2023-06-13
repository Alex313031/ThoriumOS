#!/bin/bash

## TrImLy
# trimly.sh
## VER. 0.5.1

# constants (for coloring stdout)
RED='\033[0;31m' # Red
YEL='\033[1;33m' # Yellow
NC='\033[0m' # No Color

#start
printf "${RED}--------------------------------------------------------------------------------${NC}\n"
printf "\n"

printf "${RED}== TrImLy - Your fstrim automator and defrag script for ChomiumOS ==${NC}\n"
printf "\n"
printf "Note: This script must be placed in /usr/local/bin,\n made executable with 'sudo chmod +x trimly.sh',\n and run with sudo (root) priveleges.\n"
printf "\n"

# conditional defrag (*will not work entirely on bind mounts used on /)
printf "${YEL}You may optionally run e4defrag -v on the stateful_partition and root (/), note this will take some time, and\n is not needed very often on SSDs, but one should use this if installed to an HDD, as ChromiumOS has no auto-defrag. \nPlease answer 1 or 2.▼${NC}\n"
printf "\n"
	select yn in "Yes" "No"; do
    case $yn in
    	Yes ) printf "\n" && printf "${YEL}Defragmenting HDD...${NC}" && printf "\n" && e4defrag -v /dev/sda1 && printf "\n ${RED}Continuing...${NC}" && printf "\n"; break;;
        No ) printf "\n ${RED}Continuing...${NC}" && printf "\n"; break;;
    esac
done

# conditional trim (for SSD performance and longevity)
# -run fstrim on all relevant partitions and mount points.
# -mount rootfs to temp dir and fstrim them.
printf "\n${YEL}You may now optionally run fstrim on all relevant partitions, mount points,\n and the two rootfs partitions A and B. Note that the time for completion\n depends on SSD size/speed, and the amount of deletions made since last trim. \nPlease answer 1 or 2.▼${NC}\n"
printf "\n"
	select yn in "Yes" "No"; do
    case $yn in
    	Yes ) printf "\n" && printf "${YEL}TRIMming SSD...${NC}\n" && fstrim -a -v && fstrim -v /mnt/stateful_partition/encrypted && fstrim -v /usr/share/oem && fstrim -v /mnt/stateful_partition && fstrim -v / && mkdir /rootfs_A && mount /dev/sda3 /rootfs_A && fstrim -v /rootfs_A && umount /dev/sda3 && mkdir /rootfs_B && mount /dev/sda5 /rootfs_B && fstrim -v /rootfs_B && umount /dev/sda5 && printf "fstrim -v completed successfully with status code 0" && printf "\n"; break;;
        No ) printf "\n ${RED}Skipping TRIM...${NC}" && printf "\n"; break;;
    esac
done

# cleanup and exit
printf "\n"
printf "\n ${RED}Done!${NC}\n"
printf "\n-Cleaning up temporary rootfs mountpoints... (if you used TRIM)\n"
rmdir /rootfs_A
rmdir /rootfs_B
printf "\n${YEL}TrImLy has optimized your storage device for faster I/O operations!${NC} *yay*\n"
printf "${RED}--------------------------------------------------------------------------------${NC}\n"
exit

# Thanks to Ted Larson for motivating me to make this, my fellow nerd dad for too much to list here, and JCloud for fun chitchat.
# Ted Larson and JCloud are users on the CloudReady user forums.
