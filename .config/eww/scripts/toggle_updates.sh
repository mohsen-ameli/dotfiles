#!/bin/sh

current=$(eww get curr_window)

open() {
    eww open updates
    eww update curr_window="$current updates"
}

close() {
    current=$(echo $current | sed 's/ updates//')
    eww update curr_window=$current
    eww close updates
}

echo "$current" | grep "updates" && close || open
