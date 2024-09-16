#!/bin/sh
##########################
## Manages dunst notifications
##########################

EWW_HOME_DIR="$HOME/.config/eww/$($HOME/.local/bin/is-wayland --name)"

if [ "$1" = "--update" ]; then
  # update the notifications
  dunstctl history-clear
  eww update notifications="$(dunstctl history)" -c $EWW_HOME_DIR
elif [ "$1" = "--dnd" ]; then
  # toggle do not disturb
  dunstctl set-paused toggle 
  eww update dnd="$(dunstctl get-pause-level)" -c $EWW_HOME_DIR
elif [ "$1" = "--remove" ]; then
  # remove a notification
  dunstctl history-rm "$2"
  eww update notifications="$(dunstctl history)" -c $EWW_HOME_DIR
else
  # update the notifications list after a notification disappears
  sleep $((1 + $DUNST_TIMEOUT / 1000))
  eww update notifications="$(dunstctl history)" -c $EWW_HOME_DIR
fi
