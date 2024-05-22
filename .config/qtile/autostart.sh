#!/bin/bash

$HOME/.local/bin/wallpaper --random
$HOME/.local/bin/apply-themes
dunst &
nm-applet &
blueman-applet &
picom &
polybar &
