# Rendering
# nvidia-settings --load-config-only
xrandr --output eDP-1-0 --mode 1920x1080 --rate 144
xrandr --output HDMI-A-0 --mode 3840x2160 --rate 60 --left-of eDP
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrdb -merge ~/.Xresources

# Misc
sudo xinput set-prop $(xinput list | grep Touchpad | awk '{print $6}' | cut -f2 -d=) "libinput Scrolling Pixel Distance" 50
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# How fast typing is
xset r rate 300 50 &

# Wallpaper, themes, lock and sleep
$HOME/.local/bin/wallpaper --random &
$HOME/.local/bin/apply-settings &
$HOME/.local/bin/autolock &
$HOME/.local/bin/battery-alert &
$HOME/.local/bin/run-bar &

# 3rd party
dunst -config ~/.config/dunst/dunstrcx11 &
clipcatd &
picom &
sxhkd &
asusctl profile --profile-set Quiet &
asusctl --chg-limit $CHARGE_LIMIT &

# Tiling window manager
exec i3
