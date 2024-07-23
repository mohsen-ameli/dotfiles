#!/bin/sh

current=$(eww get curr_window)

open() {
    eww close $current
    eww update curr_window=control &
    eww open-many control menu-closer
}

close() {
    eww update curr_window=""
    eww close control
    eww close updates
    eww close menu-closer
}

(echo "$current" | grep "control") && close || open
