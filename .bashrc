#
# ~/.bashrc
#

# Running electron apps in wayland needs this
export ELECTRON_OZONE_PLATFORM_HINT="wayland"
export PATH="$PATH:/usr/bin/latex:/usr/bin/pdflatex"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Starship
PS1='[\u@\h \W]\$ '
eval "$(starship init bash)"

# Pywal
#(cat ~/.cache/wal/sequences &)
#cat ~/.cache/wal/sequences
#source ~/.cache/wal/colors-tty.sh
