#!/bin/sh

EWW_HOME_DIR="$HOME/.config/eww/$($HOME/.local/bin/is-wayland --name)"
window=$1
current=$(eww get curr_window -c $EWW_HOME_DIR)

open() {
    eww close $current -c $EWW_HOME_DIR
    eww update curr_window=$window -c $EWW_HOME_DIR &
    eww open-many $window menu-closer -c $EWW_HOME_DIR
}

close() {
    eww close $window menu-closer -c $EWW_HOME_DIR
    eww update curr_window="" -c $EWW_HOME_DIR
}

echo "$current" | grep "$window" && close || open
