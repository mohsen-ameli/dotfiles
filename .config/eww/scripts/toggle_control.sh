#!/bin/bash

state=$(eww get open_control)

open_control() {
    eww active-windows | grep -v "bar" | cut -f1 -d: | xargs -I {} eww close {}
    eww open control
    eww update open_control=true
}

close_control() {
    eww update open_control=false
    eww close control
    eww update open_updates=false
    eww close updates
}

case $state in
    true)
        close_control;;
    false)
        open_control;;
esac