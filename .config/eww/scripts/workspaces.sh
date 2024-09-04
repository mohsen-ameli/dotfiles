#!/bin/sh
##########################
## Current active workspace
##########################

if [ $($HOME/.local/bin/is-wayland) -eq 1 ]; then
    hyprctl activeworkspace | grep "^workspace ID " | cut -d" " -f3
    handle() {
        (echo $1 | grep "^workspace>>" > /dev/null) && echo "${1##*>}"
    }
    socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
else
    i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .name'
    handle() {
        action=$(echo "$1" | jq -r '.change')
        [ "$action" = "focus" ] && echo "$1" | jq -r '.current.name'
    }
    i3-msg -t subscribe -m '[ "workspace" ]' | while read -r line; do handle "$line"; done
fi