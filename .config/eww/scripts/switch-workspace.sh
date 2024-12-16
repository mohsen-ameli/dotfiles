#!/bin/sh
##########################
## Switches workspaces
##########################

if pgrep -x Hyprland >/dev/null; then
    hyprctl dispatch workspace $1
elif pgrep -x i3 >/dev/null; then
    i3-msg workspace $1
elif pgrep -x openbox >/dev/null; then
    wmctrl -s $(($1 - 1))
fi
