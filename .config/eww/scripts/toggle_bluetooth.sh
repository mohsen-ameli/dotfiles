#!/bin/bash

state=$(eww get open_bluetooth)

open_bluetooth() {
    if [[ -z $(eww windows | grep '*bluetooth') ]]; then
        eww open bluetooth
    fi
    eww update open_bluetooth=true
}

close_bluetooth() {
    eww update open_bluetooth=false
    eww close bluetooth
}

case $1 in
    close)
        close_bluetooth
        exit 0;;
esac

case $state in
    true)
        close_bluetooth;;
    false)
        open_bluetooth;;
esac