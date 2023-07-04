# /etc/skel/.bashrc
#
# Copyright (c) 2022 Alex313031
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.

export EDITOR=nano
export VISUAL=nano

export NINJA_SUMMARIZE_BUILD=1

alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias la='ls -A --color=auto'
alias ..='cd ..'
alias susp='sudo powerd_dbus_suspend'
alias edit='nano -m -g'
alias reb='sudo reboot'
alias clr='clear'
alias fs='sudo mount -o rw,remount /'
alias down='cd ~/MyFiles/Downloads/'
alias x='sudo chmod +x'
alias bashconf='nano -m -g ~/.bashrc'
alias conf='sudo nano -m -g /etc/chrome_dev.conf'
alias io='sudo iotop'
alias bas='source ~/.bashrc'
alias fl='sudo fdisk --list'
alias journal='cat /var/log/messages && cat /var/log/boot.log'
alias q='exit'
alias quit='exit'
alias rmdd='sudo rm -r -v '
alias sys='htop'
alias vdir='vdir --color=auto'
alias dir='dir --color=auto'
alias dir1='dir -1 -b -q'
alias it='sudo modprobe it87'
alias chro='sudo enter-chroot'
alias inst='crew install'
alias run='cd /usr/local/bin'
alias ver='cat /etc/os-release'
alias s='sync'
alias zst="tar --use-compress-program=unzstd -xvf "
alias x='sudo chmod +x '
alias c='%'
alias clone='git clone'
alias trim='sudo fstrim -a -v'
alias push="git push origin main"
alias status='git status'
alias grep2='grep -C2 --colour'
alias diff='git diff'
alias timetouch='/usr/bin/find . -exec touch {} +'
alias defrag='sudo e4defrag -v '
cd
