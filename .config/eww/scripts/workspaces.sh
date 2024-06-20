#!/bin/sh

handle() {
    echo $1 | grep "^workspace>>" | awk -F">>" '{print $2}'
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done