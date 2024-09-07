xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
xrdb -merge ~/.Xresources
sudo xinput set-prop 16 "libinput Scrolling Pixel Distance" 50
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
exec dwmblocks &
exec sxhkd &
exec $HOME/.local/bin/run-bar &
#exec dwm
exec i3
