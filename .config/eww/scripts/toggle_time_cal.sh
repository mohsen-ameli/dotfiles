#!/bin/bash

state=$(eww get open_time_cal)

open_time_cal() {
    eww active-windows | grep -v "bar" | cut -f1 -d: | xargs -I {} eww close {}
    eww open time_cal
    eww update open_time_cal=true
}

close_time_cal() {
    eww update open_time_cal=false
    eww close time_cal
}

case $state in
    true)
        close_time_cal;;
    false)
        open_time_cal;;
esac