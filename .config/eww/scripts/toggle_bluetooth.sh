#!/bin/bash

state=$(eww get open_bluetooth)

open_bluetooth() {
    eww active-windows | grep -v "bar" | cut -f1 -d: | xargs -I {} eww close {}
    eww open bluetooth
    eww update open_bluetooth=true
}

close_bluetooth() {
    eww update open_bluetooth=false
    eww close bluetooth
}

case $state in
    true)
        close_bluetooth;;
    false)
        open_bluetooth;;
esac