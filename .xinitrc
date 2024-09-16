nvidia-settings --load-config-only
xrandr --output eDP-1-0 --mode 1920x1080 --rate 144
xrandr --output HDMI-A-0 --mode 3840x2160 --rate 60 --left-of eDP
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
xrdb -merge ~/.Xresources
sudo xinput set-prop $(xinput list | grep Touchpad | awk '{print $6}' | cut -f2 -d=) "libinput Scrolling Pixel Distance" 50
# sudo xinput set-prop 16 "libinput Scrolling Pixel Distance" 20
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
$HOME/.local/bin/wallpaper --random &
xset r rate 300 50 &
$HOME/.local/bin/apply-themes &
dunst -config ~/.config/dunst/dunstrcx11 &
clipcatd &
picom &
asusctl profile --profile-set Quiet &
asusctl --chg-limit $CHARGE_LIMIT &
$HOME/.local/bin/battery-alert &
exec sxhkd &
exec $HOME/.local/bin/run-bar &
exec i3
