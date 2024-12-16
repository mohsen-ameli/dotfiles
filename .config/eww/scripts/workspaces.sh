#!/bin/sh
##########################
## Current active workspace
##########################

if pgrep -x Hyprland >/dev/null; then
    hyprctl activeworkspace | grep "^workspace ID " | cut -d" " -f3
    handle() {
        (echo $1 | grep "^workspace>>" > /dev/null) && echo "${1##*>}"
    }
    socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
elif pgrep -x i3 >/dev/null; then
    i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .name'
    handle() {
        action=$(echo "$1" | jq -r '.change')
        [ "$action" = "focus" ] && echo "$1" | jq -r '.current.name'
    }
    i3-msg -t subscribe -m '[ "workspace" ]' | while read -r line; do handle "$line"; done
elif pgrep -x openbox >/dev/null; then
    handle() {
        echo "$1" | awk '{print $3 + 1}'
    }
    xprop -spy -root _NET_CURRENT_DESKTOP | while read -r line; do handle "$line"; done
fi