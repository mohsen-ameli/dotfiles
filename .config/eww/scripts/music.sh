#!/bin/sh
##########################
## Live music info
##########################

if [ "$1" = "--player" ]; then
    playerctl metadata -F -f '{{playerName}}~{{title}}~{{album}}~{{artist}}~{{mpris:artUrl}}~{{status}}~{{mpris:length}}~{{duration(mpris:length)}}' \
    | while read -r line; do
        name=$(echo $line | cut -d~ -f1)
        title=$(echo $line | cut -d~ -f2)
        album=$(echo $line | cut -d~ -f3)
        artist=$(echo $line | cut -d~ -f4)
        artUrl=$(echo $line | cut -d~ -f5)
        artUrl=$(echo "${artUrl##*://}")
        status=$(echo $line | cut -d~ -f6)
        length=$(echo $line | cut -d~ -f7)
        lengthStr=$(echo $line | cut -d~ -f8)

        [ "$length" != "" ] && length=$(($length / 1000000))

        echo "{\"name\": \"$name\", \"album\": \"$album\", \"title\": \"$title\", \"artist\": \"$artist\", \"artUrl\": \"$artUrl\", \"status\": \"$status\", \"length\": \"$length\", \"lengthStr\": \"$lengthStr\"}"
    done
elif [ "$1" = "--position" ]; then
    playerctl metadata -F -f "{{position / 1000000}}~{{duration(position)}}" | while read -r line; do
        position=$(echo $line | cut -d~ -f1)
        position=$(echo "($position + 0.5) / 1" | bc)
        positionStr=$(echo $line | cut -d~ -f2)

        echo "{\"position\": \"$position\", \"positionStr\": \"$positionStr\"}"
        
        # JSON_STRING=$( jq -n \
        #             --arg position "$position" \
        #             --arg positionStr "$positionStr" \
        #             '{position: $position, positionStr: $positionStr}' )
        # echo $JSON_STRING
    done
fi
