#!/bin/bash
# Runs when a new notification is received

# Sleep for 5 seconds to allow the notification to be added to the history
sleep 5
eww update notifications="$(dunstctl history)"