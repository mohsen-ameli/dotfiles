#!/bin/sh
##########################
## All active workspaces
##########################

if pgrep -x Hyprland >/dev/null; then
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
elif pgrep -x i3 >/dev/null; then
    active=$(i3-msg -t get_workspaces | jq -r '.[] | .name' | xargs)
    echo "$active"
    handle() {
        action=$(echo "$1" | jq -r '.change')
        if [ "$action" = "init" ]; then
            space=$(echo "$1" | jq -r '.current.name')
            active="$active $space"
            echo "$active"
        elif [ "$action" = "empty" ]; then
            space=$(echo "$1" | jq -r '.current.name')
            active=$(echo $active | sed "s/$space//g")
            echo "$active"
        fi
    }
    i3-msg -t subscribe -m '[ "workspace" ]' | while read -r line; do handle "$line"; done
elif pgrep -x openbox >/dev/null; then
    # echo "1 2 3 4 5"
    echo ""
fi