#
# ~/.bashrc
#

# Running electron apps in wayland needs this
export ELECTRON_OZONE_PLATFORM_HINT="wayland"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Starship
PS1='[\u@\h \W]\$ '
eval "$(starship init bash)"

# Pywal
#(cat ~/.cache/wal/sequences &)
#cat ~/.cache/wal/sequences
#source ~/.cache/wal/colors-tty.sh
