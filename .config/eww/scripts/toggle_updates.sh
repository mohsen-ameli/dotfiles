#!/bin/sh

EWW_HOME_DIR="$HOME/.config/eww/$($HOME/.local/bin/is-wayland --name)"
current=$(eww get curr_window -c $EWW_HOME_DIR)

open() {
    eww open updates -c $EWW_HOME_DIR
    eww update curr_window="$current updates" -c $EWW_HOME_DIR
}

close() {
    current=$(echo $current | sed 's/ updates//')
    eww update curr_window=$current -c $EWW_HOME_DIR
    eww close updates -c $EWW_HOME_DIR
}

echo "$current" | grep "updates" && close || open
