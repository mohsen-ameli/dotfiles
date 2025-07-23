# Rendering
#xrdb -merge ~/.Xresources

# How fast typing is
#xset r rate 300 50 &

# Wallpaper, themes, lock and sleep
#$HOME/.local/bin/wallpaper --random &
#$HOME/.local/bin/apply-settings &
#$HOME/.local/bin/autolock &
#$HOME/.local/bin/battery-alert &
# $HOME/.local/bin/run-bar &

# 3rd party
#dunst -config ~/.config/dunst/dunstrcx11 &
#rm -rf $XDG_RUNTIME_DIR/clipmenu*
#clipmenud &
#picom &
#sxhkd &
#asusctl profile --profile-set Quiet &
#asusctl --chg-limit $CHARGE_LIMIT &

# Misc
#sudo xinput set-prop $(xinput list | grep Touchpad | awk '{print $6}' | cut -f2 -d=) "libinput Scrolling Pixel Distance" 50
#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# Environment
#exec i3
# exec startplasma-x11 
exec cinnamon-session
