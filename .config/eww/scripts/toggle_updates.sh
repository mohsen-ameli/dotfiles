#!/bin/sh

state=$(eww get open_updates)

open() {
    eww active-windows | grep -v "bar" | grep -v "control" | cut -f1 -d: | xargs -I {} eww close {}
    eww open updates
    eww update open_updates=true
}

close() {
    eww update open_updates=false
    eww close updates
}

case $state in
    true) close;;
    false) open;;
esac