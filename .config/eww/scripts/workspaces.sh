#!/bin/sh
##########################
## Current active workspace
##########################

# print the active workspace
hyprctl activeworkspace | grep "^workspace ID " | cut -d" " -f3

handle() {
    (echo $1 | grep "^workspace>>" > /dev/null) && echo "${1##*>}"
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done