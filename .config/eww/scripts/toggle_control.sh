#!/bin/bash

state=$(eww get open_control)

open_control() {
    # if [[ -z $(eww windows | grep '*control') ]]; then
    eww open control
    # fi
    eww update open_control=true
}

close_control() {
    eww update open_control=false
    eww close control
}

# case $1 in
#     close)
#         close_control
#         exit 0;;
# esac

case $state in
    true)
        close_control;;
    false)
        open_control;;
esac