#!/bin/sh

EWW_HOME_DIR="$HOME/.config/eww/$($HOME/.local/bin/is-wayland --name)"
current=$(eww get curr_window -c $EWW_HOME_DIR)

open() {
    eww close $current -c $EWW_HOME_DIR
    eww update curr_window=control -c $EWW_HOME_DIR &
    eww open-many control menu-closer -c $EWW_HOME_DIR
}

close() {
    eww update curr_window="" -c $EWW_HOME_DIR
    eww close control -c $EWW_HOME_DIR
    eww close updates -c $EWW_HOME_DIR
    eww close menu-closer -c $EWW_HOME_DIR
}

(echo "$current" | grep "control") && close || open
