#!/bin/bash

state=$(eww get open_updates)

open_updates() {
    eww active-windows | grep -v "bar" | grep -v "control" | cut -f1 -d: | xargs -I {} eww close {}
    eww open updates
    eww update open_updates=true
}

close_updates() {
    eww update open_updates=false
    eww close updates
}

case $state in
    true)
        close_updates;;
    false)
        open_updates;;
esac