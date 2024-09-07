#!/bin/sh
##########################
## Switches workspaces
##########################

if [ $($HOME/.local/bin/is-wayland) -eq 1 ]; then
    hyprctl dispatch workspace $1
else
    i3-msg workspace $1
fi
