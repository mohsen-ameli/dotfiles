#!/bin/sh

gen_music_json() {
    name=$(playerctl metadata -f "{{playerName}}" 2> /dev/null)
    title=$(playerctl metadata -f "{{title}}" 2> /dev/null)
    album=$(playerctl metadata -f "{{album}}" 2> /dev/null)
    artist=$(playerctl metadata -f "{{artist}}" 2> /dev/null)
    artUrl=$((playerctl metadata -f "{{mpris:artUrl}}" | awk -F'://' '{print $2}') 2> /dev/null)
    status=$(playerctl metadata -f "{{status}}" 2> /dev/null)
    length=$(playerctl metadata -f "{{mpris:length}}" 2> /dev/null)
    lengthStr=$(playerctl metadata -f "{{duration(mpris:length)}}" 2> /dev/null)

    if [ "$length" != "" ]; then
        length=$(($length / 1000000))
    fi

    echo "{\"name\": \"$name\", \"album\": \"$album\", \"title\": \"$title\", \"artist\": \"$artist\", \"artUrl\": \"$artUrl\", \"status\": \"$status\", \"length\": \"$length\", \"lengthStr\": \"$lengthStr\"}"
}

if [ "$1" = "--player" ]; then
    gen_music_json
    
    playerctl metadata -F -f '{{playerName}} {{title}} {{ album }} {{artist}} {{mpris:artUrl}} {{status}} {{mpris:length}}' | while read -r line; do
        gen_music_json

        # JSON_STRING=$( jq -n \
        #             --arg name "$name" \
        #             --arg title "$title" \
        #             --arg album "$album" \
        #             --arg artist "$artist" \
        #             --arg artUrl "$artUrl" \
        #             --arg status "$status" \
        #             --arg length "$length" \
        #             --arg lengthStr "$lengthStr" \
        #             '{name: $name, album: $album, title: $title, artist: $artist, artUrl: $artUrl, status: $status, length: $length, lengthStr: $lengthStr}' )
        # echo $JSON_STRING
    done
elif [ "$1" = "--position" ]; then
    playerctl metadata -F -f '{{position}}' | while read -r line; do
        position=$(playerctl metadata -f "{{position / 1000000}}")
        position=$(echo "($position + 0.5) / 1" | bc)
        positionStr=$(playerctl metadata -f "{{duration(position)}}")

        JSON_STRING=$( jq -n \
                    --arg position "$position" \
                    --arg positionStr "$positionStr" \
                    '{position: $position, positionStr: $positionStr}' )
        echo $JSON_STRING

    done
fi
