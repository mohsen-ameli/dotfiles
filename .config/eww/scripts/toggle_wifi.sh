#!/bin/bash

state=$(eww get open_wifi)

open_wifi() {
    eww active-windows | grep -v "bar" | cut -f1 -d: | xargs -I {} eww close {}
    eww open wifi
    eww update open_wifi=true
}

close_wifi() {
    eww update open_wifi=false
    eww close wifi
}

case $state in
    true)
        close_wifi;;
    false)
        open_wifi;;
esac