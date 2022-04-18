#!/bin/bash

# Copyright (c) 2022 Alex313031

YEL='\033[1;33m' # Yellow

printf "\n" &&
printf "${YEL}Creating overlay-amd-frick overlay dir, and merging files from overlay-amd-generic and this repo to the overlay dir.\n" &&
tput sgr0 &&

mkdir -p -v ~/chromiumos/src/overlays/overlay-amd64-frick &&
printf "\n" &&
cp -r -v ~/chromiumos/src/overlays/overlay-amd64-generic/* ~/chromiumos/src/overlays/overlay-amd64-frick/ &&
cp -r -v ../overlay-amd64-frick/* ~/chromiumos/src/overlays/overlay-amd64-frick/ &&
printf "\n" &&

printf "${YEL}Done!\n" &&

printf "\n" &&
printf "${YEL}Copying other files from this repo into //chromiumos/src/platform/\n" &&
tput sgr0 &&

cp -r -v ../overlay-amd64-frick/platform/* ~/chromiumos/src/platform/
printf "\n" &&
printf "${YEL}Done!\n" &&
printf "\n" &&

printf "${YEL}To add amd-frick to the list of known boards in cros-board.eclass, run this command:\n" &&
printf "\n" &&
tput sgr0 &&

echo "sed -i 's/ALL_BOARDS=(/ALL_BOARDS=(\n	amd64-frick\n/' ${HOME}/chromiumos/src/third_party/chromiumos-overlay/eclass/cros-board.eclass" &&

printf "\n" &&
printf "${YEL}Listing contents of ~/chromiumos.\n" &&
tput sgr0 &&

cd ~/chromiumos &&
ls -A --color=auto &&

printf "\n" &&
printf "${YEL}Enjoy ThoriumOS!"
printf "\n" &&
tput sgr0 &&

echo "
      __________________________      
     |.------------------------.|     
     ||                        ||     
     ||                        ||     
     ||    (_)          (_)    ||     
     ||                        ||     
     ||     \ __________ /     ||     
     ||                        ||     
     ||________________________||     
    //__/__/__/__/__\__\__\__\__\\    
   //__/__/__/__/____\__\__\__\__\\   
  /       /________________\       \  
 /__________________________________\ 
 \__________________________________/ 
                                      " &&
printf "\n" &&

cd ~/chromiumos

exit 0
