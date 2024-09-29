#!/bin/sh

EWW_HOME_DIR="$HOME/.config/eww/$($HOME/.local/bin/is-wayland --name)"
weather=$($HOME/.local/bin/weather --live)
eww update weather="$weather" -c $EWW_HOME_DIR