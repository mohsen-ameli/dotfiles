#!/bin/bash

state=$(eww get open_weather)

open_weather() {
    if [[ -z $(eww windows | grep '*weather') ]]; then
        eww open weather
    fi
    eww update open_weather=true
}

close_weather() {
    eww update open_weather=false
    eww close weather
}

case $1 in
    close)
        close_weather
        exit 0;;
esac

case $state in
    true)
        close_weather;;
    false)
        open_weather;;
esac