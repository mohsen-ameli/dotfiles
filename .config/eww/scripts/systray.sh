#!/bin/sh
##########################
## Live system tray count
##########################

count=0

dbus-monitor --session "interface='org.kde.StatusNotifierWatcher'" |
while read -r signal; do
  if echo $signal | grep "StatusNotifierItemRegistered" > /dev/null; then
    count=$(($count + 1))
  elif echo $signal | grep "StatusNotifierItemUnregistered" > /dev/null; then
    count=$(($count - 1))
  fi

  echo $count
done