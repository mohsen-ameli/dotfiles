#!/bin/bash

state=$(eww get open_wifi)

open_wifi() {
    if [[ -z $(eww windows | grep '*wifi') ]]; then
        eww open wifi
    fi
    eww update open_wifi=true
}

close_wifi() {
    eww update open_wifi=false
    eww close wifi
}

case $1 in
    close)
        close_wifi
        exit 0;;
esac

case $state in
    true)
        close_wifi;;
    false)
        open_wifi;;
esac