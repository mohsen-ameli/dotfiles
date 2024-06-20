#!/bin/bash

state=$(eww get open_time_cal)

open_time_cal() {
    # if [[ -z $(eww windows | grep '*time_cal') ]]; then
    eww open time_cal
    # fi
    eww update open_time_cal=true
}

close_time_cal() {
    eww update open_time_cal=false
    eww close time_cal
}

case $1 in
    close)
        close_time_cal
        exit 0;;
esac

case $state in
    true)
        close_time_cal;;
    false)
        open_time_cal;;
esac