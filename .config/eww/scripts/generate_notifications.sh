#!/bin/bash

notifs=$(dunstctl history | grep -i -A 2 "message" | grep "data" | awk -F: '{gsub(/"/," "); print $2}')
icons=$(dunstctl history | grep -i -A 2 "icon_path" | grep "data" | awk -F: '{gsub(/"/," "); print $2}')
ids=$(dunstctl history | grep -i -A 2 "id" | grep "data" | awk -F: '{gsub(/"/," "); print $2}')

# (box :class "control-box" :orientation "v"
#     (label :markup "<b>hello</b>")
#     (label :markup "world")
#     (button "X")
# )

echo -e """(defwidget dunst []
    (box :orientation \"v\" :spacing 12
""" > $HOME/.config/eww/dunst.yuck

i=1

dunstctl history | grep -i -A 2 "message" | grep "data" | awk -F: '{gsub(/"/," "); print $2}' | while read -r notification; do
    # I don't know why awk can't split the string by \n
    title=$(echo "$notification" | sed 's/\\n/<>/' | awk -F '<>' '{print $1}')
    body=$(echo "$notification" | sed 's/\\n/<>/' | awk -F '<>' '{print $2}')
    # icon=$(echo "$icons" | sed -n "$i"p)
    icon=$(echo -e $(echo $icons | sed 's/ /\\n/g') | awk "NR==$i {print}")
    i=$((i+1))
    

    if [[ $body == "" ]]; then
        echo -e """
            (button :onclick \"notify-send a\" 
                (box :space-evenly false :spacing 12 :class \"control-box\" :orientation \"h\"
                    (image :path \"$icon\" :image-width 25 :image-height 25)
                    (label :markup \"$title\")
                )
            )""" >> $HOME/.config/eww/dunst.yuck
    else
        echo -e """
            (button :onclick \"notify-send a\" 
                (box :space-evenly false :spacing 12 :class \"control-box\" :orientation \"h\"
                    (image :path \"$icon\" :image-width 25 :image-height 25)
                    (box :orientation \"v\"
                        (label :markup \"$title\")
                        (label :markup \"$body\")
                    )
                )
            )""" >> $HOME/.config/eww/dunst.yuck
    fi
    
done

echo "))" >> $HOME/.config/eww/dunst.yuck
