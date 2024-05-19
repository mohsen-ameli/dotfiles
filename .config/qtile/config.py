# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess
import json
from libqtile import bar, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from time import sleep
from libqtile import hook

BG_COLOR = "3B7A57"
BG_COLOR = "427021"
BG_COLOR = "3F704D"
BG_COLOR = "004B49"
BG_COLOR = "1C352D"
TEXT_COLOR = "ffffff"
MARGIN = 7
mod = "mod4"
terminal = guess_terminal()


@hook.subscribe.startup_once
def autostart():
    subprocess.Popen(
        "/home/moe/.config/qtile/autostart.sh",
        shell=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )


def run_script(file: str):
    p = subprocess.Popen(
        file, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT
    )
    line = p.stdout.readlines()[0]
    return line.decode("UTF-8").split("\n")[0]


keys = [
    Key([], "XF86AudioLowerVolume", lazy.spawn(".local/bin/volume --dec")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn(".local/bin/volume --inc")),
    Key([], "XF86AudioMicMute", lazy.spawn(".local/bin/volume --toggle-mic")), #not working
    Key([], "XF86Launch1", lazy.spawn(".local/bin/rog-control-center")),

    Key([], "XF86AudioMute", lazy.spawn(".local/bin/volume --toggle")), #F1
    Key([], "XF86KbdBrightnessUp", lazy.spawn(".local/bin/rog --inc")), #F2
    Key([], "XF86KbdBrightnessDown", lazy.spawn(".local/bin/rog --dec")), #F3
    # Key(["mod1"], "F4", lazy.spawn(".local/bin/rog --aura")), #F4 not working
    Key(["mod1"], "F5", lazy.spawn(".local/bin/rog --profile-toggle")), #F5 not working
    Key(["mod1"], "F6", lazy.spawn(".local/bin/screenshot --portion")), #F6 not working
    Key([], "XF86MonBrightnessUp", lazy.spawn(".local/bin/brightness --inc")), #F7
    Key([], "XF86MonBrightnessDown", lazy.spawn(".local/bin/brightness --dec")), #F8
    Key([mod], "q", lazy.window.kill()),
    Key([mod, "shift"], "r", lazy.restart()),
    Key([mod], "e", lazy.spawn("thunar")),
    Key([mod], "d", lazy.spawn("rofi -show drun")),
    Key([mod], "w", lazy.spawn(".local/bin/dmenu-wallpaper")),
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod], "left", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod], "right", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod], "down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod], "up", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key(
        [mod, "control"],
        "left",
        lazy.layout.grow_left(),
        desc="Grow window to the left",
    ),
    Key(
        [mod, "control"],
        "right",
        lazy.layout.grow_right(),
        desc="Grow window to the right",
    ),
    Key([mod, "control"], "down", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "up", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod],
        "t",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    Key([mod], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod], "m", lazy.shutdown(), desc="Shutdown Qtile"),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

groups = [Group(i) for i in "12345"]

for i in groups:
    keys.extend(
        [
            # mod1 + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
        ]
    )

layouts = [
    layout.Columns(
        border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4, margin=MARGIN
    ),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="sans",
    fontsize=20,
    padding=10,
)
extension_defaults = widget_defaults.copy()


def get_mem():
    # i = 0
    # while True:
    #     print(i)
    #     sleep(0.5)
    #     i += 1
    return run_script(".local/bin/used-mem")


def get_weather():
    text = run_script(".local/bin/weather")
    return json.loads(text)["text"]


def show_powermenu():
    qtile.spawn(".local/bin/dmenu-power")

screens = [
    Screen(
        top=bar.Bar(
            [
                # widget.TextBox(fmt=f"  {run_script(".local/bin/updates")}", foreground=TEXT_COLOR),
                widget.ThermalSensor(
                    format=" {temp:.1f}{unit}", foreground=TEXT_COLOR
                ),
                widget.Memory(
                    measure_mem="G",
                    format="  {MemUsed: .1f}{mm}",
                    foreground=TEXT_COLOR,
                ),
                widget.CPU(format="󰍛 {load_percent}%", foreground=TEXT_COLOR),
                widget.Systray(icon_size=28, padding=4),
                widget.Spacer(),
                widget.GroupBox(
                    hide_unused=True,
                    active=TEXT_COLOR,
                    inactive=TEXT_COLOR,
                    highlight_method="block",
                ),
                widget.Spacer(),
                # widget.TextBox(fmt=f"{get_weather()}", foreground=TEXT_COLOR),
                widget.Wlan(format="{essid} {percent:2.0%}", foreground=TEXT_COLOR),
                widget.PulseVolume(unmute_format="{}{volume}%", limit_max_volume=True, emoji_list=['🔇', '󰕿', '󰖀', '󰕾', ''], emoji=True),
                widget.TextBox(fmt=f"{run_script(".local/bin/battery")}", foreground=TEXT_COLOR),
                widget.Clock(format="%_I:%M %p", foreground=TEXT_COLOR),
                widget.TextBox(
                    fmt="",
                    foreground=TEXT_COLOR,
                    mouse_callbacks={"Button1": show_powermenu},
                ),
            ],
            25,
            margin=MARGIN,
            opacity=0.8,
            background=BG_COLOR,
            color="000000",
            border_color=BG_COLOR,
            border_width=10,
            border_radius=10,
        ),
        # gap=bar.Gap(5)
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
        # wallpaper='/home/moe/.config/wallpapers/landscape.jpg',
        # wallpaper_mode='fill',
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
