#!/bin/sh

active=$(hyprctl workspaces | grep "^workspace ID " | cut -d" " -f 3 | xargs)
echo "$active"

handle() {
    if echo "$1" | grep "^createworkspace>>"; then
        space=$(echo "${1##*>}")
        active="$active $space"
        echo "$active"
    elif echo "$1" | grep "^destroyworkspace>>"; then
        space=$(echo "${1##*>}")
        active=$(echo $active | sed "s/$space//g")
        echo "$active"
    fi
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done