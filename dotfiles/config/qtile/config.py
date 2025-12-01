# ==============================
# Qtile Wayland – Config Nord
# Lenovo X230 + CachyOS
# Barra B (Equilibrada)
# ==============================

import os
import subprocess
from libqtile import bar, layout, widget, hook
from libqtile.config import Key, Group, Match, Screen
from libqtile.lazy import lazy

# ------------------------------
# VARIABLES
# ------------------------------

mod = "mod4"
terminal = "foot"
launcher = "wofi --show drun"
font = "JetBrainsMono Nerd Font"
nord = {
    "bg": "#2E3440",
    "fg": "#ECEFF4",
    "fg2": "#D8DEE9",
    "blue": "#88C0D0",
    "cyan": "#8FBCBB",
    "green": "#A3BE8C",
    "yellow": "#EBCB8B",
    "red": "#BF616A",
    "orange": "#D08770",
    "purple": "#B48EAD",
    "dark": "#3B4252",
    "darker": "#434C5E",
    "darkest": "#4C566A",
}

# ------------------------------
# KEYS
# ------------------------------

keys = [
    # Launch apps
    Key([mod], "Return", lazy.spawn(terminal), desc="Terminal"),
    Key([mod], "r", lazy.spawn(launcher), desc="Wofi launcher"),

    # Window management
    Key([mod], "q", lazy.window.kill(), desc="Close window"),
    Key([mod], "Tab", lazy.next_layout(), desc="Next layout"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Fullscreen"),

    # Focus
    Key([mod], "j", lazy.layout.down(), desc="Focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Focus up"),

    # Move windows
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move up"),

    # Volume
    Key([], "XF86AudioRaiseVolume",
        lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")),
    Key([], "XF86AudioLowerVolume",
        lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")),
    Key([], "XF86AudioMute",
        lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")),

    # Brightness
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-")),

    # Qtile managment
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile")
    ]

# ------------------------------
# GROUPS
# ------------------------------

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys += [
        Key([mod], i.name, lazy.group[i.name].toscreen()),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
    ]

# ------------------------------
# LAYOUTS
# ------------------------------

layouts = [
    layout.MonadTall(
        margin=4,
        border_focus=nord["blue"],
        border_normal=nord["darkest"],
        border_width=2,
    ),
    layout.Max(),
]

# ------------------------------
# WIDGETS – Barra B (Equilibrada)
# ------------------------------

def nord_bar():
    return bar.Bar([
        widget.GroupBox(
            highlight_method="block",
            this_current_screen_border=nord["blue"],
            active=nord["fg"],
            inactive=nord["darkest"],
            rounded=False,
            padding=5,
            fontsize=14,
        ),

        widget.Spacer(),

        widget.CPU(
            format="CPU {load_percent}%",
            foreground=nord["cyan"],
            padding=5
        ),

        widget.Memory(
            format="RAM {MemUsed:.0f}MB",
            measure_mem="M",
            foreground=nord["green"],
            padding=5
        ),

        widget.ThermalSensor(
            format="TEMP {temp:.0f}°C",
            tag_sensor="Package id 0",
            foreground=nord["orange"],
            padding=5
        ),

        widget.Backlight(
            backlight_name="intel_backlight",
            format="☀ {percent:2.0%}",
            foreground=nord["yellow"],
            padding=5
        ),

        widget.Volume(
            fmt=" {}",
            foreground=nord["cyan"],
            padding=5
        ),

        widget.Battery(
            format="BAT {percent:2.0%}",
            foreground=nord["purple"],
            padding=5
        ),

        widget.Wlan(
            interface="wlan0",
            format="WIFI {essid}",
            foreground=nord["blue"],
            padding=5
        ),

        widget.Clock(
            format="%Y-%m-%d  %H:%M",
            foreground=nord["fg2"],
            padding=8
        ),

        widget.Systray(),

    ], 28, background=nord["bg"])

# ------------------------------
# SCREENS
# ------------------------------

screens = [Screen(top=nord_bar())]

# ------------------------------
# AUTOSTART
# ------------------------------

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.Popen([home])
# ------------------------------
# FLOATING RULES
# ------------------------------

from libqtile.config import Match
from libqtile import layout

floating_layout = layout.Floating(
    border_focus=nord["blue"],
    border_normal=nord["darkest"],
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirm"),
        Match(wm_class="dialog"),
        Match(wm_class="error"),
        Match(wm_class="file_progress"),
        Match(wm_class="pinentry-gtk"),
        Match(title="pinentry"),
    ]
)

# ------------------------------

wmname = "qtile-wayland"

