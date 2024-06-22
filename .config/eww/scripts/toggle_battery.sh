#!/bin/bash

state=$(eww get open_battery)

open_battery() {
    if [[ -z $(eww windows | grep '*battery') ]]; then
        eww open battery
    fi
    eww update open_battery=true
}

close_battery() {
    eww update open_battery=false
    eww close battery
}

case $1 in
    close)
        close_battery
        exit 0;;
esac

case $state in
    true)
        close_battery;;
    false)
        open_battery;;
esac