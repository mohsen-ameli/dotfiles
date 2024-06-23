#!/bin/bash

state=$(eww get open_weather)

open_weather() {
    eww active-windows | grep -v "bar" | cut -f1 -d: | xargs -I {} eww close {}
    eww open weather
    eww update open_weather=true
}

close_weather() {
    eww update open_weather=false
    eww close weather
}

case $state in
    true)
        close_weather;;
    false)
        open_weather;;
esac