xrdb -merge ~/.Xresources
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
exec $HOME/.local/bin/wallpaper --random &
xset r rate 300 50 &
$HOME/.local/bin/apply-themes &
dunst &
#picom &
asusctl profile --profile-set Quiet &
asusctl --chg-limit 80 &
$HOME/.local/bin/battery-alert &
slstatus &
sxhkd &
exec dwm
