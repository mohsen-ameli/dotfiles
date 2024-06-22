#!/bin/bash

active=$(hyprctl workspaces | grep "^workspace ID " | cut -d" " -f 3 | xargs)

echo "$active"

handle() {
    if [[ $1 =~ "createworkspace>>" ]]; then
        space=$(echo $1 | awk -F">>" '{print $2}')
        active="$active $space"
    elif [[ $1 =~ "destroyworkspace>>" ]]; then
        space=$(echo $1 | awk -F">>" '{print $2}')
        active=$(echo $active | sed "s/$space//g")
    fi
    echo "$active"
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done